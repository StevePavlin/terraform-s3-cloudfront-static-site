variable "domain" {
  type        = string
  description = "domain name to be pointed towards the static site (ex. google.com)"
  default     = ""
}

variable "index_document" {
  type        = string
  description = "Index page to be used for website. Defaults to index.html"
  default     = "index.html"
}