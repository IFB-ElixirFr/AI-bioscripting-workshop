# ============================================================
# Atelier IA & Bioscripting 2026 — Guide essentiel ask_ai()
# 12 juin 2026
# ============================================================
# Run the blocks one by one
# BEWARE: some commands have to be edited manually (e.g. your API key, you questions)
# ============================================================

# ── BLOC 1 : INITIALISATION ─────────────────────────────────
# À exécuter UNE SEULE FOIS en début de session

library(httr2)
library(jsonlite)
library(base64enc)

# Remplacer "VOTRE_CLE_ICI" par l'identifiant de la clé API 
# disponible sur le canal TCHAP "iabioscripting2-TP-participants-BA"
Sys.setenv(OPENROUTER_API_KEY = "VOTRE_CLE_ICI")

# Choisissez votre modèle — décommentez celui de votre groupe
# MODELE_CHOISI <- "anthropic/claude-sonnet-4-5"   # Claude (Anthropic)
MODELE_CHOISI <- "openai/gpt-4o"               # GPT-4o (OpenAI)
# MODELE_CHOISI <- "mistralai/mistral-large"      # Mistral Large
# MODELE_CHOISI <- "google/gemini-pro-1.5"        # Gemini Pro 1.5
# MODELE_CHOISI <- "meta-llama/llama-3.3-70b-instruct"  # Llama 3.3 (gratuit)

## Directories
workdir <- getwd()
message("Working directory: ", workdir)
analysis_dir <- file.path(workdir, "analysis")
message("Analysis directory: ", analysis_dir)
dir.create(analysis_dir, showWarnings = FALSE, recursive = TRUE)

# vérifiez que le fichier fig2A_Scerevisiae_heatmap_cible.png est présent, snon téléchargez-le
fig2a <- file.path(analysis_dir, "heatmap_yeast_cell-cycle.png")
if (file.exists(fig2a)) {
  message("heatmap file\t", fig2a)
} else {
  message("First download the files with the script download_cell-cycle_files.R")
  stop("missing file\t", fig2a)
}

# vérifiez que cell-cycle_SCERE_iabioscripting2.txt apparaît
data_table <- file.path(analysis_dir, "oscillating-genes_1705_normalized-profiles.tsv")
if (file.exists(data_table)) {
  message("data table\t", data_table)
} else {
  message("First download the files with the script download_cell-cycle_files.R")
  stop("missing file\t", data_table)
}


# Fonction pour questions texte
ask_ai <- function(prompt, model = MODELE_CHOISI, max_tokens = 2000) {
  api_key <- Sys.getenv("OPENROUTER_API_KEY")
  response <- request("https://openrouter.ai/api/v1/chat/completions") |>
    req_headers("Authorization" = paste("Bearer", api_key),
                "content-type"  = "application/json") |>
    req_body_json(list(model = model, max_tokens = max_tokens,
      messages = list(list(role = "user", content = prompt)))) |>
    req_perform()
  result <- response |> resp_body_json()
  cat(result$choices[[1]]$message$content)
  invisible(result$choices[[1]]$message$content)
}

# Fonction AVEC mémoire de conversation
historique <- list()

ask_ai_memo <- function(prompt, model = MODELE_CHOISI, max_tokens = 2000) {
  api_key <- Sys.getenv("OPENROUTER_API_KEY")
  
  # Ajouter le message de l'utilisateur à l'historique
  historique[[length(historique) + 1]] <<- list(role = "user", content = prompt)
  
  response <- request("https://openrouter.ai/api/v1/chat/completions") |>
    req_headers("Authorization" = paste("Bearer", api_key),
                "content-type"  = "application/json") |>
    req_body_json(list(model = model, max_tokens = max_tokens,
                       messages = historique)) |>
    req_perform()
  
  result <- response |> resp_body_json()
  reponse_texte <- result$choices[[1]]$message$content
  
  # Ajouter la réponse de l'IA à l'historique
  historique[[length(historique) + 1]] <<- list(role = "assistant", content = reponse_texte)
  
  cat(reponse_texte)
  invisible(reponse_texte)
}

# Pour repartir d'une conversation vide
reset_historique <- function() {
  historique <<- list()
}

# Fonction pour questions avec image (Claude, GPT-4o, Gemini uniquement)
# Pour simplifier, placez la figure dans votre répertoire de travail RStudio
ask_ai_vision <- function(prompt, image_path, model = MODELE_CHOISI, max_tokens = 2000) {
  api_key <- Sys.getenv("OPENROUTER_API_KEY")
  img_b64 <- base64encode(image_path)
  response <- request("https://openrouter.ai/api/v1/chat/completions") |>
    req_headers("Authorization" = paste("Bearer", api_key),
                "content-type"  = "application/json") |>
    req_body_json(list(model = model, max_tokens = max_tokens,
      messages = list(list(role = "user", content = list(
        list(type = "image_url",
             image_url = list(url = paste0("data:image/png;base64,", img_b64))),
        list(type = "text", text = prompt)))))) |>
    req_perform()
  result <- response |> resp_body_json()
  cat(result$choices[[1]]$message$content)
  invisible(result$choices[[1]]$message$content)
}


# ── BLOC 2 : TEST DE CONNEXION ───────────────────────────────
# Vérifiez la réponse et ne passez à la suite que si ça répond

# Vous pouvez poser toutes les questions sous ce format :
ask_ai("Dis-moi 'Hello world' en français.")

# NB: si vous observez une réponse  tronquée, vous pouvez augmenter le nombre de tokens :
ask_ai("Votre question", max_tokens = 4000)

# Pour garder la réponse dans une variable :
reponse <- ask_ai("Votre question")

# ── BLOC 4 : QUESTION SUR LA FIGURE HEATMAP ─────────────────

ask_ai_vision(
  prompt     = "Quelle est l'échelle de temps représentée sur l'axe x ?",
  image_path = fig2a
)


# ── BLOC 5 : QUESTION AVEC DONNÉES ──────────────────────────


table1 <- readLines(data_table, n = 3)

ask_ai(paste0(
  "Voici les 3 premières lignes de ma table d'expression :\n",
  paste(table1, collapse = "\n"),
  "\n\nQuel est le séparateur ? Comment charger ce fichier en R ?"
))


# ── ERREURS FRÉQUENTES ───────────────────────────────────────
# Texte vert dans RStudio   → guillemets typographiques, retapez-les manuellement
# req_perform() introuvable → relancez library(httr2)
# HTTP 401                  → clé API incorrecte, vérifiez Sys.getenv("OPENROUTER_API_KEY")
# HTTP 404                  → nom de modèle incorrect, vérifiez MODELE_CHOISI
# HTTP 429                  → trop de requêtes, attendez 30 sec et relancez
# Timeout SSL               → instabilité réseau, attendez 1-2 min et relancez
# Réponse tronquée          → ajoutez max_tokens = 4000

# ============================================================
