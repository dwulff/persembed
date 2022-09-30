library(tidyverse)
library(openai)

neo_df <- read_csv("1_data/neo_df.csv")

instruction <- "The following pages contain phrases describing people's behaviors. Please use the rating scale 
next to each phrase to describe how accurately each statement describes you. 
Describe yourself as you generally are now, not as you wish to be in the future. Describe yourself 
as you honestly see yourself, in relation to other people you know of the same sex as you are, 
and roughly your same age.

1 = Inaccurate
2 = Moderately Inaccurate
3 = Neither
4 = Moderately Accurate
5 = Accurate

"

get_response <- function(item) {
  response <- create_completion(
    engine_id = "text-davinci-002",
    prompt = paste0(instruction, item),
    temperature = 0.7,
    max_tokens = 5
  )
  return(response$choices$text %>% str_sub(-1))
}

gpt3_text_davinci_002 <- map(neo_df$text, get_response)

gpt3_result <- unlist(gpt3_text_davinci_002) %>% as.numeric()

gpt_3 <- tibble(
  item = neo_df$text,
  response = gpt3_result
)

write_delim(gpt_3, "1_data/gpt3_text_davinci_002.tsv", delim = "\t")
