library(googlesheets)
library(systemfonts)
gs = gs_url("https://docs.google.com/spreadsheets/d/1K1Jqy3CeCtRYtgC3RiC1FICqQFA8sCy2h5UafiAFk-U/edit#gid=1332971556")

niaid_dark_blue = "#153C57"
niaid_medium_blue = "#0F627C"
niaid_bright_blue = "#379AC1"
niaid_accent_blue = "#83c5da"
niaid_grey = "#D6D6D6"

df = gs_read(gs)

counts = df %>% group_by(generalPurpose) %>% count(schemaorgCompliant)


# by category -------------------------------------------------------------
ggplot(counts, aes(x = generalPurpose, y = n, fill=schemaorgCompliant)) + 
  geom_bar(stat="identity") +
  coord_flip() +
  scale_x_discrete(labels = c("specialist", "general purpose")) +
  scale_fill_manual(values = c("TRUE" = niaid_bright_blue, "FALSE" = niaid_grey, "TBD" = "green"), labels=c("no", "figshare/immport", "yes"), na.value="pink", name = "schema.org-compliant") +
  ggtitle("General purpose repositories adopt schema.org standards more than specialist ones", subtitle = "Number of repositories with schema.org-compliant datasets") + 
  theme_minimal() +
  theme(text = element_text(size = 16), title = element_text(size=10), axis.ticks.y = element_blank(), panel.grid.major.y = element_blank(), axis.title.y = element_blank(), axis.title.x = element_blank())

cats = df %>% rowwise() %>% mutate(cats = str_split(category, ", ")) %>% 
  select(schemaorgCompliant, cats) %>% 
  unnest(cols = c(cats))

cats %>% group_by(cats) %>% count(schemaorgCompliant) %>% mutate(pct = n/sum(n)) %>% filter(schemaorgCompliant == FALSE) %>% arrange(desc(pct)) %>% View()
