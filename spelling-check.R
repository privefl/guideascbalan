if (!exists("WORDS_TO_IGNORE")) WORDS_TO_IGNORE <- character(0)

# Spelling check
spelling_errors <- spelling::spell_check_files(
  path = `if`(interactive(), rstudioapi::getSourceEditorContext()$path,
              knitr::current_input()),
  ignore = c(scan("WORDLIST", ""), WORDS_TO_IGNORE),
  lang = "fr_FR"
)

if (nrow(spelling_errors)) {
  capture.output(print(spelling_errors), file = "spelling.errors")
  stop("Check spelling! Check file 'spelling.errors'")
}

rm(WORDS_TO_IGNORE, spelling_errors)
