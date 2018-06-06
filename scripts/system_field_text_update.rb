rsf = IO.read(ARGV[0])
File.write(ARGV[0], rsf.gsub!(/\tuser\t([\w-]+)/m, "\tsystem\tfield:" + '\1'))
