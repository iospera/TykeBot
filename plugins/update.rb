config :update_script, :default=>'~/deploy/tykebot/current/scripts/run_update.sh', :description=>'The script to run when update is called'
config :github_jid, :default=>'github-services@jabber.org', :description=>'jabber id of the github xmpp hook'

command do
#  aliases '[TykeBot]' # a small hack to make this work...
  description 'Make bot update to the latest revision'

  action :is_public=>false do |message|
    send(:text=>"One of my masters told me I need an update.  So I'm gonna just do that right now...")
    timer(3){updatescript}
  end

#  action :required=>:details, :description => 'Internal action for updating based upon GitHub XMPP updates.' do |message,details|
#    info = details.match(/^(\w+) pushed (\d+) new commits to master:.+$/)
#    if bot.sender(message) == config.github_jid && info
#      # info[1] is who, info[2] is number of commits
#      bot.send(:text=>"A checkin on GitHub by #{info[1]} has initiated a bot update.  One moment please...\n\n#{details}")
#      # give it a few seconds to let the room know...
#      timer(3){updatescript}
#    end
#  end
end

on :firehose do |bot,message|
    info = details.match(/^\[TykeBot\] (\w+) pushed (\d+) new commits to master:.+$/)
    if bot.sender(message) == config.github_jid && info
      # info[1] is who, info[2] is number of commits
      bot.send(:text=>"A checkin on GitHub by #{info[1]} has initiated a bot update.  One moment please...\n\n#{details}")
      # give it a few seconds to let the room know...
      timer(3){updatescript}
    end
end

helper :updatescript do
  `#{config.update_script}`
end
