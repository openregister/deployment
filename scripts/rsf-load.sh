# Use like this

# echo -e 'add-item\t{"register-name":"Persons for the data sharing agreements under chapters 1, 2, 3 and 4 of Part 5 of the Digital Economy Act 2017"}\nappend-entry\tsystem\tregister-name\t2018-04-24T15:48:52Z\tsha-256:8fb454aecd3f493e248b6a014cb569a0a2782cf6d8ff1d9689474a658211e4d7' | ../rsf-load.sh https://data-sharing-agreement-person-0001.cloudapps.digital openregister sds8sdf99g0a87

# Where the final string is the register's password from registers-pass

# And the sha256 has is the has of all of the below, including the curly braces

# {"register-name":"Persons for the data sharing agreements under chapters 1, 2, 3 and 4 of Part 5 of the Digital Economy Act 2017"}

curl -v -X POST --data-binary @- -u $2:$3 $1/load-rsf --header "Content-Type:application/uk-gov-rsf"
