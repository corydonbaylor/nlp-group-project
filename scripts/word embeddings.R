library(text2vec)

text8_file = "~/text8"

unzip ("text8.zip", files = "text8", exdir = "~/")

wiki = readLines(text8_file, n = 1, warn = FALSE)

# Create iterator over tokens
tokens <- space_tokenizer(wiki) 

# Create vocabulary. Terms will be unigrams (simple words).
it = itoken(tokens, progressbar = FALSE)
vocab <- create_vocabulary(it)

vocab <- prune_vocabulary(vocab, term_count_min = 5L)
vectorizer <- vocab_vectorizer(vocab)

tcm <- create_tcm(it, vectorizer, skip_grams_window = 5L)


glove = GlobalVectors$new(rank = 50, x_max = 10)
shakes_wv_main = glove$fit_transform(tcm, n_iter = 100, convergence_tol = 0.001)

wv_context = glove$components
word_vectors = shakes_wv_main  + t(wv_context)

berlin = word_vectors["paris", , drop = FALSE] -
  word_vectors["france", , drop = FALSE] +
  word_vectors["germany", , drop = FALSE]

berlin_cos_sim = sim2(x = word_vectors, y = berlin, method = "cosine", norm = "l2")
head(sort(berlin_cos_sim[,1], decreasing = TRUE), 5)