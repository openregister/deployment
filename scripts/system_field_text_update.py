import sys
import re

file_path = sys.argv[1:][0]
with open(file_path, 'r' ) as read_file:
  rsf = read_file.read()
  system_entry = re.sub(r'\tuser\t([\w-]+)', r'\tsystem\tfield:\1', rsf, flags = re.M)
  with open(file_path, "w") as write_file:
    write_file.write(system_entry)