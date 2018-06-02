#!fish

function __fish_very_install
    very search
end

function __fish_very_remove
    very list
end

function __fish_very_using_command
  set cmd (commandline -opc)
  if [ (count $cmd) -gt 1 ]
    if [ $argv[1] = $cmd[2] ]
      return 0
    end
  end
  return 1
end

function __fish_very_needs_command
  set cmd (commandline -opc)
  if [ (count $cmd) -eq 1 -a $cmd[1] = 'very' ]
    return 0
  end
  return 1
end

function __fish_very_additional_needs_command
  set cmd (commandline -opc)
  if [ (count $cmd) -eq 1 -a $cmd[1] = 'very' ]
    return 0
  end
  return 1
end

set -l dlist (very --_completion description)
set -l count 1

for x in (very --_completion ls)
	complete -f -c very -n '__fish_very_needs_command' -a $x -d $dlist[$count]
	set -l count (math $count + 1)
end

complete -f -c very -n '__fish_very_using_command install' -a '(__fish_very_install)'
complete -f -c very -n '__fish_very_using_command remove' -a '(__fish_very_remove)'

for x in (very --_completion additional)
  for y in (very --_completion cmd)
    complete -f -c very -n '__fish_very_additional_needs_command' -a $y
  end
end