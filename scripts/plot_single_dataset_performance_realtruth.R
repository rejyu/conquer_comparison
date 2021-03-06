plot_performance_realtruth <- function(cobraperf, colvec, exts = exts, summary_data = list()) {
  summary_data$FDRTPR <- fdrtpr(cobraperf)
  summary_data$AUROC <- cobraperf@roc %>% dplyr::group_by(method) %>%
    dplyr::summarize(AUROC = max(AUC, na.rm = TRUE))
  
  sizes_ncells <- unique(paste(get_nsamples(basemethods(cobraperf)), 
                               get_repl(basemethods(cobraperf)), sep = "."))
  for (szi in sizes_ncells) {
    spl <- strsplit(szi, "\\.")[[1]]
    keepmethods <- basemethods(cobraperf)[get_nsamples(basemethods(cobraperf)) == spl[1] 
                                          & get_repl(basemethods(cobraperf)) == spl[2]]
    c2 <- structure(colvec, names = paste0(names(colvec),
                                           ".", spl[1], ".", spl[2]))
    cobraplot <- 
      prepare_data_for_plot(cobraperf, 
                            colorscheme = c2[keepmethods],
                            keepmethods = keepmethods)
    print(plot_fdrtprcurve(cobraplot, plottype = c("points", "curve"), 
                           pointsize = 3), stripsize = 0)
    print(plot_roc(cobraplot))
  }

  for (s in unique(fdrtpr(cobraperf)$thr)) {
    ## FDR/TPR
    tmp <- fdrtpr(cobraperf) %>% dplyr::filter(thr == s) %>%
      tidyr::separate(method, into = c("method", "ncells", "repl"), sep = "\\.") %>%
      dplyr::mutate(method = gsub(exts, "", method)) %>%
      dplyr::mutate(ncells = paste0(ncells, " cells per group")) %>%
      dplyr::mutate(ncells = factor(ncells, levels = paste0(sort(as.numeric(as.character(unique(gsub(" cells per group", "", ncells))))), " cells per group")))
    
    for (asp in c("FDR", "TPR")) {
      p <- tmp %>% 
        ggplot(aes_string(x = "method", y = asp, color = "method", shape = "ncells"))
      if (asp == "FDR") p <- p + geom_hline(yintercept = as.numeric(gsub("thr", "", s)))
      p <- p + 
        geom_point(size = 4) + theme_bw() + ggtitle(paste0("FDR threshold ", gsub("thr", "", s))) +
        scale_color_manual(values = structure(colvec, names = gsub(exts, "", names(colvec))), name = "") + 
        theme(axis.text.x = element_text(size = 12, angle = 90, hjust = 1, vjust = 0.5),
              axis.text.y = element_text(size = 12),
              axis.title = element_text(size = 13)) + 
        xlab("")
      print(p)
      
      p <- tmp %>%
        ggplot(aes_string(x = "method", y = asp, color = "method"))
      if (asp == "FDR") p <- p + geom_hline(yintercept = as.numeric(gsub("thr", "", s)))
      p <- p + 
        facet_wrap(~ncells) + 
        geom_point(size = 4) + theme_bw() + ggtitle(paste0("FDR threshold ", gsub("thr", "", s))) +
        scale_color_manual(values = structure(colvec, names = gsub(exts, "", names(colvec))), name = "") + 
        theme(axis.text.x = element_text(size = 12, angle = 90, hjust = 1, vjust = 0.5),
              axis.text.y = element_text(size = 12),
              axis.title = element_text(size = 13)) + 
        xlab("")
      print(p)
      
      p <- tmp %>%
        ggplot(aes_string(x = "ncells", y = asp, color = "method", group = "method"))
      if (asp == "FDR") p <- p + geom_hline(yintercept = as.numeric(gsub("thr", "", s)))
      p <- p + 
        geom_point(alpha = 0.25) + geom_smooth(se = FALSE) + theme_bw() + 
        ggtitle(paste0("FDR threshold ", gsub("thr", "", s))) +
        scale_color_manual(values = structure(colvec, names = gsub(exts, "", names(colvec))), name = "") + 
        theme(axis.text.x = element_text(size = 12, angle = 90, hjust = 1, vjust = 0.5),
              axis.text.y = element_text(size = 12),
              axis.title = element_text(size = 13)) + 
        xlab("")
      print(p)
    }
  }
  
  ## AUROC
  tmp <- cobraperf@roc %>% dplyr::group_by(method) %>%
    dplyr::summarize(AUROC = max(AUC, na.rm = TRUE)) %>%
    tidyr::separate(method, into = c("method", "ncells", "repl"), sep = "\\.") %>%
    dplyr::mutate(method = gsub(exts, "", method)) %>%
    dplyr::mutate(ncells = paste0(ncells, " cells per group")) %>%
    dplyr::mutate(ncells = factor(ncells, levels = paste0(sort(as.numeric(as.character(unique(gsub(" cells per group", "", ncells))))), " cells per group")))
  print(tmp %>% ggplot(aes(x = method, y = AUROC, color = method, shape = ncells)) + 
          geom_point(size = 4) + theme_bw() + 
          scale_color_manual(values = structure(colvec, names = gsub(exts, "", names(colvec))), name = "") + 
          theme(axis.text.x = element_text(size = 12, angle = 90, hjust = 1, vjust = 0.5),
                axis.text.y = element_text(size = 12),
                axis.title = element_text(size = 13)) + 
          xlab(""))
  print(tmp %>% ggplot(aes(x = method, y = AUROC, color = method)) + 
          facet_wrap(~ncells) + 
          geom_point(size = 4) + theme_bw() +
          scale_color_manual(values = structure(colvec, names = gsub(exts, "", names(colvec))), name = "") + 
          theme(axis.text.x = element_text(size = 12, angle = 90, hjust = 1, vjust = 0.5),
                axis.text.y = element_text(size = 12),
                axis.title = element_text(size = 13)) + 
          xlab(""))
  print(tmp %>%
          ggplot(aes(x = ncells, y = AUROC, color = method, group = method)) + 
          geom_point(alpha = 0.25) + geom_smooth(se = FALSE) + theme_bw() + 
          scale_color_manual(values = structure(colvec, names = gsub(exts, "", names(colvec))), name = "") + 
          theme(axis.text.x = element_text(size = 12, angle = 90, hjust = 1, vjust = 0.5),
                axis.text.y = element_text(size = 12),
                axis.title = element_text(size = 13)) + 
          xlab(""))
  
  return(invisible(summary_data))
}
