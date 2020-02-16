library(jsonlite)

example_json = jsonlite::fromJSON(paste0("https://lookup.binlist.net/<<FIRST 8 DIGITS OF CREDIT CARD>>"))

example_df = data.frame(
  bank = example_json$bank$name,
  name = example_json$brand,
  schema = example_json$scheme
)
