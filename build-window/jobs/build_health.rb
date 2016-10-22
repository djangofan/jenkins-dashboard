
SUCCESS = 'Successful'
FAILED = 'Failed'

def api_functions
  return {
    'Jenkins' => lambda { |build_id| get_jenkins_build_health build_id}
  }
end

def get_url(url)
  parsed = begin
    @authInfo = YAML::load_file(File.join(__dir__, '../auth.yml'))
  rescue ArgumentError => e
    puts "Could not parse YAML: #{e.message}"
  end
  
  puts "AUTH: #{@authInfo.inspect.to_s}"

  uri = URI.parse(@authInfo['url'])
  http = Net::HTTP.new(uri.host, uri.port)
  
  if uri.scheme == 'https'
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  end
  
  request = Net::HTTP::Get.new(uri.request_uri)

  request.basic_auth(@authInfo['username'] ,@authInfo['password'] )

  http.set_debug_output($stdout)
  
  response = http.request(request)
  return JSON.parse(response.body)
end

def calculate_health(successful_count, count)
  return (successful_count / count.to_f * 100).round
end

def get_build_health(build)
  api_functions[build['server']].call(build['id'])
end

def get_jenkins_build_health(build_id)
  url = "#{Builds::BUILD_CONFIG['jenkinsBaseUrl']}/job/#{build_id}/api/json?tree=builds[status,timestamp,id,result,duration,url,fullDisplayName]"
url = "#{Builds::BUILD_CONFIG['jenkinsBaseUrl']}/job/#{build_id}/api/json"

  puts "URL: " + url
  
  build_info = get_url URI.encode(url)
  builds = build_info['builds']
  builds_with_status = builds.select { |build| !build['result'].nil? }
  successful_count = builds_with_status.count { |build| build['result'] == 'SUCCESS' }
  latest_build = builds_with_status.first
  return {
    name: latest_build['fullDisplayName'],
    status: latest_build['result'] == 'SUCCESS' ? SUCCESS : FAILED,
    duration: latest_build['duration'] / 1000,
    link: latest_build['url'],
    health: calculate_health(successful_count, builds_with_status.count),
    time: latest_build['timestamp']
  }
end

SCHEDULER.every '20s' do
  Builds::BUILD_LIST.each do |build|
    send_event(build['id'], get_build_health(build))
  end
end
