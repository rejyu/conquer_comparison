summarize_de_characteristics <- function(figdir, datasets, exts, dtpext, cols,
                                         singledsfigdir, cobradir, concordancedir, 
                                         dschardir, origvsmockdir) {
  plots <- list()
  
  charname <- c(cvtpm = "CV(TPM)", fraczero = "Fraction zeros", 
                log2_avetpm = "log2(average TPM)", log2_vartpm = "log2(variance(TPM))")
  
  pdf(paste0(figdir, "/summary_de_characteristics", paste(exts, collapse = "_"), dtpext, ".pdf"), 
      width = 12, height = 7)
  
  charac <- do.call(rbind, lapply(datasets, function(ds) {
    do.call(rbind, lapply(exts, function(e) {
      readRDS(paste0(singledsfigdir, "/results_characterization/", ds, e, 
                     "_results_characterization_summary_data.rds"))$stats_charac
    }))
  }))
  
  ## Define colors for plotting
  cols <- structure(cols, names = gsub(paste(exts, collapse = "|"), "", names(cols)))
  
  for (stat in c("tstat")) {
    x <- charac %>% dplyr::filter_(paste0("!is.na(", stat, ")")) %>% 
      dplyr::filter_(paste0("is.finite(", stat, ")")) %>% 
      dplyr::filter(charac != "fraczerodiff") %>%
      dplyr::filter(charac != "fraczeroround") %>%
      dplyr::filter(charac != "log2_avecount") %>%
      tidyr::separate(Var2, into = c("method", "ncells", "repl"), sep = "\\.") %>%
      dplyr::mutate(charac = charname[charac]) %>%
      dplyr::mutate(method = gsub(paste(exts, collapse = "|"), "", method))

    ## Visualize summary statistics for each characteristic
    statname <- switch(stat,
                       tstat = "t-statistic comparing significant \nand non-significant genes",
                       mediandiff = "median difference between \nsignificant and non-significant genes")
    p <- x %>% 
      ggplot(aes_string(x = "method", y = stat, color = "method", shape = "dataset")) + 
      geom_hline(yintercept = 0) + geom_point() + theme_bw() + 
      facet_wrap(~charac, scales = "free_y") + xlab("") + ylab(statname) + 
      theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5, size = 12),
            axis.text.y = element_text(size = 12),
            axis.title.y = element_text(size = 13)) + 
      scale_color_manual(values = cols) + 
      guides(color = guide_legend(ncol = 2, title = ""),
             shape = guide_legend(ncol = 2, title = ""))
    plots[[paste0(stat, "_bystat")]] <- p
    print(p)
      
    p <- x %>% 
      ggplot(aes_string(x = "charac", y = stat, color = "method", shape = "dataset")) + 
      geom_hline(yintercept = 0) + geom_point() + theme_bw() + 
      facet_wrap(~method, scales = "fixed") + xlab("") + ylab(statname) + 
      theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5, size = 12),
            axis.text.y = element_text(size = 12),
            axis.title.y = element_text(size = 13)) + 
      scale_color_manual(values = cols) + 
      guides(color = guide_legend(ncol = 2, title = ""),
             shape = guide_legend(ncol = 2, title = ""))
    plots[[paste0(stat, "_bymethod")]] <- p
    print(p)
    
    p <- x %>% dplyr::group_by(charac) %>% 
      dplyr::mutate_(stat = paste0("(", stat, "-mean(", stat, "))/sd(", stat, ")")) %>% 
      dplyr::ungroup() %>% as.data.frame() %>%
      ggplot(aes_string(x = "charac", y = "stat", color = "method", shape = "dataset")) + 
      geom_hline(yintercept = 0) + 
      geom_point() + theme_bw() + facet_wrap(~method, scales = "fixed") + 
      xlab("") + ylab(paste0(statname, ",\ncentered and scaled across all instances)")) + 
      theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5, size = 12),
            axis.text.y = element_text(size = 12),
            axis.title.y = element_text(size = 13)) + 
      scale_color_manual(values = structure(cols, names = gsub(exts, "", names(cols)))) + 
      guides(color = guide_legend(ncol = 2, title = ""),
             shape = guide_legend(ncol = 2, title = ""))
    plots[[paste0(stat, "_bymethod_scaled")]] <- p
    print(p)
  }
  dev.off()
  
  ## -------------------------- Final summary plots ------------------------- ##
  pdf(paste0(figdir, "/de_characteristics_final", paste(exts, collapse = "_"), 
             dtpext, ".pdf"), width = 10, height = 6)
  p <- plots[["tstat_bystat"]] + 
    theme(legend.position = "bottom") + 
    guides(colour = FALSE,
           shape = guide_legend(nrow = 2,
                                title = "",
                                override.aes = list(size = 1.5),
                                title.theme = element_text(size = 12, angle = 0),
                                label.theme = element_text(size = 12, angle = 0),
                                keywidth = 1, default.unit = "cm"))
  print(p)
  dev.off()

}