variable "filename_env" {
  type        = list(string)
  description = "env for each usernames and passwords files"
  default     = ["dev", "prod"]
}