resource "local_file" "usernames" {
  count           = 2
  filename        = "${path.module}/usernames${count.index}.txt"
  content         = "mark, \nimane"
  file_permission = "0700"
}

resource "local_sensitive_file" "users_passwords" {
  for_each        = toset(var.filename_env)
  filename        = "${path.module}/passwords-${each.key}.txt"
  content         = "bonjour123-${each.key}"
  file_permission = "0700"
}