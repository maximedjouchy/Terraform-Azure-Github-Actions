output "sensitive_filenames" {
  value = [for f in local_sensitive_file.users_passwords : f.filename]
}

output "filename" {
  value = local_file.usernames.*.filename
  sensitive = true
}