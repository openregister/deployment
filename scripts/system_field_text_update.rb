rsf = IO.read(ARGV[0])
File.write(ARGV[0], rsf.gsub!(/\t(user)\t((\w|-)+)/m, "\tsystem\tfield:" + '\2'))
