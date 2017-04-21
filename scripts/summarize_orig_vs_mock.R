summarize_orig_vs_mock <- function(figdir, datasets, exts, dtpext, cols,
                                   singledsfigdir, cobradir, concordancedir, 
                                   dschardir, origvsmockdir) {
  ## Generate list to hold all plots
  plots <- list()
  
  ttest <- function(x, y) {
    tryCatch({
      t.test(y[x == "signal"], y[x == "mock"], var.equal = FALSE)$stat
    }, error = function(e) NA)
  }
  
  plots <- list()
  
  pdf(paste0(figdir, "/summary_orig_vs_mock", dtpext, ".pdf"), 
      width = 10, height = 7)
  
  concordances <- do.call(rbind, lapply(datasets, function(ds) {
    do.call(rbind, lapply(exts, function(e) {
      readRDS(paste0(origvsmockdir, "/", ds, e, 
                     "_orig_vs_mock_summary_data.rds"))$concordances %>%
        dplyr::ungroup() %>%
        dplyr::mutate(method = gsub(paste(exts, collapse = "|"), "", method))
    }))
  }))
  
  for (f in unique(concordances$filt)) {
    concs <- concordances %>% dplyr::filter(filt == f)
    nbr_keep <- unique(intersect(subset(concs, tp == "signal")$ncells,
                                 subset(concs, tp == "mock")$ncells))
    
    concsum <- concs %>% as.data.frame() %>%
      dplyr::filter(ncells %in% nbr_keep) %>%
      dplyr::group_by(dataset, ncells, method) %>% 
      dplyr::summarize(tstat = ttest(tp, AUCs),
                       mediandiff = median(AUCs[tp == "signal"]) - median(AUCs[tp == "mock"]))
    
    p <- concs %>% dplyr::filter(tp == "signal") %>%
      dplyr::filter(ncells %in% nbr_keep) %>%
      ggplot(aes(x = method, y = AUCs, col = method)) + 
      geom_boxplot(outlier.size = -1) + ylim(0, 1) + 
      geom_point(position = position_jitter(width = 0.2), size = 0.5, aes(shape = dataset)) + 
      theme_bw() + xlab("") + ylab("Area under concordance curve, signal data set") + 
      scale_color_manual(values = structure(cols, names = gsub(exts, "", names(cols))), name = "") + 
      scale_shape_discrete(name = "") +
      theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5, size = 12),
            axis.text.y = element_text(size = 12),
            axis.title.y = element_text(size = 13)) + 
      ggtitle(f)
    print(p)
    plots[[paste0("auc_signal_comb_", f)]] <- p
    
    p <- concs %>% dplyr::filter(tp == "mock") %>%
      dplyr::filter(ncells %in% nbr_keep) %>%
      ggplot(aes(x = method, y = AUCs, col = method)) + 
      geom_boxplot(outlier.size = -1) + ylim(0, 1) + 
      geom_point(position = position_jitter(width = 0.2), size = 0.5, aes(shape = dataset)) + 
      theme_bw() + xlab("") + ylab("Area under concordance curve, mock data set") + 
      scale_color_manual(values = structure(cols, names = gsub(exts, "", names(cols))), name = "") + 
      scale_shape_discrete(name = "") +
      theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5, size = 12),
            axis.text.y = element_text(size = 12),
            axis.title.y = element_text(size = 13)) + 
      ggtitle(f)
    print(p)
    plots[[paste0("auc_mock_comb_", f)]] <- p
    
    p <- concs %>% dplyr::filter(tp == "signal") %>%
      dplyr::filter(ncells %in% nbr_keep) %>%
      ggplot(aes(x = method, y = AUCs, col = method)) + 
      geom_boxplot(outlier.size = -1) + ylim(0, 1) + 
      geom_point(position = position_jitter(width = 0.2), size = 0.5) + 
      facet_wrap(~dataset) + 
      theme_bw() + xlab("") + ylab("Area under concordance curve, signal data set") + 
      scale_color_manual(values = structure(cols, names = gsub(exts, "", names(cols))), name = "") + 
      scale_shape_discrete(name = "") +
      theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5, size = 12),
            axis.text.y = element_text(size = 12),
            axis.title.y = element_text(size = 13)) + 
      ggtitle(f)
    print(p)
    plots[[paste0("auc_signal_sep_", f)]] <- p
    
    p <- concs %>% dplyr::filter(tp == "mock") %>%
      dplyr::filter(ncells %in% nbr_keep) %>%
      ggplot(aes(x = method, y = AUCs, col = method)) + 
      geom_boxplot(outlier.size = -1) + ylim(0, 1) + 
      geom_point(position = position_jitter(width = 0.2), size = 0.5) + 
      facet_wrap(~dataset) + 
      theme_bw() + xlab("") + ylab("Area under concordance curve, signal data set") + 
      scale_color_manual(values = structure(cols, names = gsub(exts, "", names(cols))), name = "") + 
      scale_shape_discrete(name = "") +
      theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5, size = 12),
            axis.text.y = element_text(size = 12),
            axis.title.y = element_text(size = 13)) + 
      ggtitle(f)
    print(p)
    plots[[paste0("auc_mock_sep_", f)]] <- p
    
    p <- concsum %>% 
      ggplot(aes(x = method, y = sign(tstat) * sqrt(abs(tstat)), col = method)) + 
      geom_boxplot(outlier.size = -1) +
      geom_point(position = position_jitter(width = 0.2), size = 1.5, aes(shape = dataset)) +
      theme_bw() + xlab("") + ylab("sqrt(t-statistic, area under \nconcordance curve (signal - mock))") + 
      scale_color_manual(values = structure(cols, names = gsub(exts, "", names(cols))), name = "") + 
      scale_shape_discrete(name = "") +
      theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5, size = 12),
            axis.text.y = element_text(size = 12),
            axis.title.y = element_text(size = 13)) + 
      ggtitle(f)
    print(p)
    plots[[paste0("tstat_auc_", f)]] <- p
    
    p <- concsum %>% 
      ggplot(aes(x = method, y = mediandiff, col = method)) + 
      geom_boxplot(outlier.size = -1) +
      geom_point(position = position_jitter(width = 0.2), size = 1.5, aes(shape = dataset)) +
      theme_bw() + xlab("") + 
      ylab("difference between median area under \nconcordance curve (signal - mock)") + 
      scale_color_manual(values = structure(cols, names = gsub(exts, "", names(cols))), name = "") + 
      scale_shape_discrete(name = "") +
      theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5, size = 12),
            axis.text.y = element_text(size = 12),
            axis.title.y = element_text(size = 13)) + 
      ggtitle(f)
    print(p)
    plots[[paste0("mediandiff_auc_", f)]] <- p
  }  
  dev.off()
  
  ## -------------------------- Final summary plots ------------------------- ##
  pdf(paste0(figdir, "/orig_vs_mock_final", dtpext, ".pdf"), width = 12, height = 12)
  p <- plot_grid(plot_grid(plots$auc_signal_comb_ + theme(legend.position = "none"), 
                           plots$auc_mock_comb_ + theme(legend.position = "none"),
                           labels = c("A", "B"), align = "h", rel_widths = c(1, 1), nrow = 1),
                 plots$tstat_auc_ + theme(legend.position = "none"),
                 get_legend(plots$tstat_auc_ + theme(legend.position = "bottom") + 
                              guides(colour = FALSE,
                                     shape = 
                                       guide_legend(nrow = 2,
                                                    title = "",
                                                    title.theme = element_text(size = 12,
                                                                               angle = 0),
                                                    label.theme = element_text(size = 12,
                                                                               angle = 0),
                                                    keywidth = 1, default.unit = "cm"))),
                 rel_heights = c(1.7, 1.7, 0.1), ncol = 1, labels = c("", "C", ""))
  print(p)
  dev.off()
  
}