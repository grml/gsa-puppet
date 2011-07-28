class cfengine {

define append_if_no_such_line($file, $line, $refreshonly = 'false') {
   exec { "/bin/echo '$line' >> '$file'":
      unless      => "/bin/grep -Fxqe '$line' '$file'",
      path        => "/bin",
      refreshonly => $refreshonly,
   }
}

define delete_lines($file, $pattern) {
   exec { "sed -i -r -e '/$pattern/d' $file":
      path   => "/bin",
      onlyif => "/bin/grep -E '$pattern' '$file'",
   }
}

}
