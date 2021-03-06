## Define the version of R and the path to the library
R := R_LIBS=/home/Shared/Rlib/release-3.4-lib/ /usr/local/R/R-3.3.1/bin/R CMD BATCH --no-restore --no-save

## Define paths
cobradir := output/cobra_data
concordancedir := output/concordances
relperfdir := output/relative_performance
realperfdir := output/performance_realtruth
figdir := figures
singledsfigdir := figures/single_dataset
multidsfigdir := figures/multi_dataset
dschardir := figures/dataset_characteristics

## Define the active datasets and methods
include include_methods.mk
include include_datasets.mk
include include_filterings.mk

## Plot types
PLOTTYPE := timing results_characterization results_relativetruth consistency results_relativetruth_all truefpr
PLOTTYPE1 := timing results_characterization results_relativetruth truefpr
PLOTTYPE2 := consistency
PLOTTYPE3 := results_relativetruth_all
PLOTTYPE4 := performance_realtruth
SUMMARYTYPE1 := truefpr crossmethod_consistency orig_vs_mock
SUMMARYTYPE2 := de_characteristics relfprtpr
SUMMARYTYPE3 := fracNA nbrdet
DSTYPE1 := real sim bulk
DSTYPE2 := real sim
DSTYPE3 := real bulk

.PHONY: all

## Define the default rule
all: plotds plotind plotorigmock \
$(addsuffix _real.rds, $(addprefix $(multidsfigdir)/filtering/summary_filtering_, $(foreach F,$(FILT),$(F)))) \
$(addsuffix _sim.rds, $(addprefix $(multidsfigdir)/filtering/summary_filtering_, $(foreach F,$(FILT),$(F)))) \
$(addsuffix _bulk.rds, $(addprefix $(multidsfigdir)/filtering/summary_filtering_, $(foreach F,$(FILT),$(F)))) \
$(multidsfigdir)/timing/summary_timing_all.rds \
$(multidsfigdir)/tsne/summary_tsne_all.rds \
$(multidsfigdir)/trueperformance/summary_trueperformance_sim.rds \
$(multidsfigdir)/ds_characteristics/summary_ds_characteristics_real.rds \
$(addsuffix .rds, $(addprefix $(multidsfigdir)/, $(foreach D,$(DSTYPE1),$(foreach S,$(SUMMARYTYPE1),$(S)/summary_$(S)_$(D))))) \
$(addsuffix .rds, $(addprefix $(multidsfigdir)/, $(foreach D,$(DSTYPE2),$(foreach S,$(SUMMARYTYPE2),$(S)/summary_$(S)_$(D))))) \
$(addsuffix .rds, $(addprefix $(multidsfigdir)/, $(foreach D,$(DSTYPE3),$(foreach S,$(SUMMARYTYPE3),$(S)/summary_$(S)_$(D))))) \
figures/misc/voomlimma_investigation.rds

## Plot original vs mock comparison
plotorigmock: $(addsuffix _orig_vs_mock_summary_data.rds, $(addprefix $(figdir)/orig_vs_mock/, $(foreach Y,$(Dsb),$(Y)))) \
$(addsuffix _orig_vs_mock_summary_data.rds, $(addprefix $(figdir)/orig_vs_mock/, $(foreach F,$(FILT),$(foreach Y,$(Dsb),$(Y)_$(F))))) \
$(addsuffix _orig_vs_mock_summary_data.rds, $(addprefix $(figdir)/orig_vs_mock/, $(foreach Y,$(Dsbsim),$(Y)))) \
$(addsuffix _orig_vs_mock_summary_data.rds, $(addprefix $(figdir)/orig_vs_mock/, $(foreach F,$(FILT),$(foreach Y,$(Dsbsim),$(Y)_$(F))))) \
$(addsuffix _orig_vs_mock_summary_data.rds, $(addprefix $(figdir)/orig_vs_mock/, $(foreach Y,$(DSbulksignal),$(Y)))) \
$(addsuffix _orig_vs_mock_summary_data.rds, $(addprefix $(figdir)/orig_vs_mock/, $(foreach F,$(FILT),$(foreach Y,$(DSbulksignal),$(Y)_$(F)))))

## Plot individual data set results
plotind: $(addsuffix _summary_data.rds, $(addprefix $(singledsfigdir)/, $(foreach P,$(PLOTTYPE),$(foreach Y,$(DS),$(P)/$(Y)_$(P))))) \
$(addsuffix _summary_data.rds, $(addprefix $(singledsfigdir)/, $(foreach P,$(PLOTTYPE),$(foreach F,$(FILT),$(foreach Y,$(DS),$(P)/$(Y)_$(F)_$(P)))))) \
$(addsuffix _summary_data.rds, $(addprefix $(singledsfigdir)/, $(foreach P,$(PLOTTYPE4),$(foreach Y,$(DSsimsignal),$(P)/$(Y)_$(P))))) \
$(addsuffix _summary_data.rds, $(addprefix $(singledsfigdir)/, $(foreach P,$(PLOTTYPE4),$(foreach F,$(FILT),$(foreach Y,$(DSsimsignal),$(P)/$(Y)_$(F)_$(P)))))) \
$(addsuffix _summary_data.rds, $(addprefix $(singledsfigdir)/, $(foreach P,$(PLOTTYPE),$(foreach Y,$(DSbulk),$(P)/$(Y)_$(P))))) \
$(addsuffix _summary_data.rds, $(addprefix $(singledsfigdir)/, $(foreach P,$(PLOTTYPE),$(foreach F,$(FILT),$(foreach Y,$(DSbulk),$(P)/$(Y)_$(F)_$(P))))))

## Plot data set characteristics
plotds: $(addsuffix _dataset_characteristics_summary_data.rds, $(addprefix $(dschardir)/, $(foreach Y,$(DS),$(Y)))) \
$(addsuffix _dataset_characteristics_summary_data.rds, $(addprefix $(dschardir)/, $(foreach F,$(FILT),$(foreach Y,$(DS),$(Y)_$(F))))) \
$(addsuffix _dataset_characteristics_summary_data.rds, $(addprefix $(dschardir)/, $(foreach Y,$(DSbulk),$(Y)))) \
$(addsuffix _dataset_characteristics_summary_data.rds, $(addprefix $(dschardir)/, $(foreach F,$(FILT),$(foreach Y,$(DSbulk),$(Y)_$(F)))))

## Prepare results for plotting, step II
plotprepare: $(addsuffix _concordances.rds, $(addprefix $(concordancedir)/, $(foreach Y,$(DS),$(Y)))) \
$(addsuffix _concordances.rds, $(addprefix $(concordancedir)/, $(foreach F,$(FILT),$(foreach Y,$(DS),$(Y)_$(F))))) \
$(addsuffix _concordances.rds, $(addprefix $(concordancedir)/, $(foreach Y,$(DSbulk),$(Y)))) \
$(addsuffix _concordances.rds, $(addprefix $(concordancedir)/, $(foreach F,$(FILT),$(foreach Y,$(DSbulk),$(Y)_$(F))))) \
$(addsuffix _relative_performance.rds, $(addprefix $(relperfdir)/, $(foreach Y,$(DS),$(Y)))) \
$(addsuffix _relative_performance.rds, $(addprefix $(relperfdir)/, $(foreach F,$(FILT),$(foreach Y,$(DS),$(Y)_$(F))))) \
$(addsuffix _relative_performance.rds, $(addprefix $(relperfdir)/, $(foreach Y,$(DSbulk),$(Y)))) \
$(addsuffix _relative_performance.rds, $(addprefix $(relperfdir)/, $(foreach F,$(FILT),$(foreach Y,$(DSbulk),$(Y)_$(F))))) \
$(addsuffix _performance.rds, $(addprefix $(realperfdir)/, $(foreach Y,$(DSsimsignal),$(Y)))) \
$(addsuffix _performance.rds, $(addprefix $(realperfdir)/, $(foreach F,$(FILT),$(foreach Y,$(DSsimsignal),$(Y)_$(F)))))

## Prepare results for plotting, step I
cobra: $(addsuffix _cobra.rds, $(addprefix $(cobradir)/, $(foreach Y,$(DS),$(Y)))) \
$(addsuffix _cobra.rds, $(addprefix $(cobradir)/, $(foreach F,$(FILT),$(foreach Y,$(DS),$(Y)_$(F))))) \
$(addsuffix _cobra.rds, $(addprefix $(cobradir)/, $(foreach Y,$(DSbulk),$(Y)))) \
$(addsuffix _cobra.rds, $(addprefix $(cobradir)/, $(foreach F,$(FILT),$(foreach Y,$(DSbulk),$(Y)_$(F)))))

## Run differential expression
diffexp: $(addsuffix .rds, $(addprefix results/, $(foreach M,$(MT),$(foreach Y,$(DS),$(Y)_$(M))))) \
$(addsuffix .rds, $(addprefix results/, $(foreach F,$(FILT),$(foreach M,$(MT),$(foreach Y,$(DS),$(Y)_$(M)_$(F)))))) \
$(addsuffix .rds, $(addprefix results/, $(foreach M,$(MTbulk),$(foreach Y,$(DSbulk),$(Y)_$(M))))) \
$(addsuffix .rds, $(addprefix results/, $(foreach F,$(FILT),$(foreach M,$(MTbulk),$(foreach Y,$(DSbulk),$(Y)_$(M)_$(F))))))

## List all packages
listpackages:
	$(R) scripts/list_packages.R Rout/list_packages.Rout

## Simulate data
sim: $(addsuffix .rds, $(addprefix data/, $(foreach Y,$(DSforsim),$(Y)sim123))) \
$(addsuffix .rds, $(addprefix data/, $(foreach Y,$(DSforsim),$(Y)sim123mock)))

## List all rules
list:
	@$(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$' | xargs

## Make sure no intermediate files are deleted
.SECONDARY:

## -------------------------- Generate configuration files ---------------------------- ##
## ------------------------------------------------------------------------------------ ##
define configrule
config/$(1).json: scripts/generate_config_$(1).R
	$(R) scripts/generate_config_$(1).R Rout/generate_config_$(1).Rout
endef
$(foreach Y,$(DS),$(eval $(call configrule,$(Y))))
$(foreach Y,$(DSbulk),$(eval $(call configrule,$(Y))))

## --------------------------------- Simulate data ------------------------------------ ##
## ------------------------------------------------------------------------------------ ##
define simrule
data/$(1)sim$(2).rds: scripts/simulate_data.R data/$(1).rds config/$(1).json scripts/powsim_modified_functions.R
	$(R) "--args dataset='$(1)' config_file='config/$(1).json' pDE=0.1 seed=$(2)" scripts/simulate_data.R Rout/simulate_data_$(1)_$(2).Rout
endef
$(foreach Y,$(DSforsim),$(eval $(call simrule,$(Y),123)))

define simrulemock
data/$(1)sim$(2)mock.rds: data/$(1)sim$(2).rds
	scp data/$(1)sim$(2).rds data/$(1)sim$(2)mock.rds
endef
$(foreach Y,$(DSforsim),$(eval $(call simrulemock,$(Y),123)))

## --------------------------- Extract sample subsets --------------------------------- ##
## ------------------------------------------------------------------------------------ ##
define subsetrule
subsets/$(1)_subsets.rds: data/$(1).rds config/$(1).json scripts/generate_subsets.R
	$(R) "--args config_file='config/$(1).json'" scripts/generate_subsets.R Rout/generate_subsets_$(1).Rout
endef
$(foreach Y,$(DS),$(eval $(call subsetrule,$(Y))))
$(foreach Y,$(DSbulk),$(eval $(call subsetrule,$(Y))))

## -------------------------- Generate Usoskin data set ------------------------------- ##
## ------------------------------------------------------------------------------------ ##
data/UsoskinGSE59739.rds: scripts/generate_Usoskin_mae.R data/Usoskin_External_resources_Table_1.txt
	$(R) scripts/generate_Usoskin_mae.R Rout/generate_Usoskin_mae.Rout

## ------------------ Define rules for differential expression ------------------------ ##
## ------------------------------------------------------------------------------------ ##
define dgerule
results/$(1)_$(2)$(4).rds: scripts/apply_$(2).R scripts/prepare_mae.R scripts/run_diffexpression.R subsets/$(1)_subsets.rds data/$(1).rds
	$(R) "--args config_file='config/$(1).json' demethod='$(2)' filt='$(3)'" scripts/run_diffexpression.R Rout/run_diffexpression_$(1)_$(2)$(4).Rout
endef
$(foreach M,$(MT),$(foreach Y,$(DS),$(eval $(call dgerule,$(Y),$(M),,))))
$(foreach M,$(MTbulk),$(foreach Y,$(DSbulk),$(eval $(call dgerule,$(Y),$(M),,))))
$(foreach F,$(FILT),$(foreach M,$(MT),$(foreach Y,$(DS),$(eval $(call dgerule,$(Y),$(M),$(F),_$(F))))))
$(foreach F,$(FILT),$(foreach M,$(MTbulk),$(foreach Y,$(DSbulk),$(eval $(call dgerule,$(Y),$(M),$(F),_$(F))))))

## ------------------ Prepare COBRAData object for evaluation ------------------------- ##
## ------------------------------------------------------------------------------------ ##
define cobrarule
$(cobradir)/$(1)$(3)_cobra.rds: scripts/prepare_cobra_for_evaluation.R scripts/calculate_gene_characteristics.R \
$(addsuffix $(3).rds, $(addprefix results/$(1)_, $(foreach M,$(4),$(M)))) scripts/prepare_mae.R include_methods.mk
	$(R) "--args demethods='$(5)' dataset='$(1)' config_file='config/$(1).json' filt='$(2)' resdir='results' outdir='$(cobradir)'" scripts/prepare_cobra_for_evaluation.R Rout/prepare_cobra_for_evaluation_$(1)$(3)$(6).Rout
endef
$(foreach Y,$(DS),$(eval $(call cobrarule,$(Y),,,$(MT),${MTc},)))
$(foreach Y,$(DSbulk),$(eval $(call cobrarule,$(Y),,,$(MTbulk),${MTcbulk},_bulk)))
$(foreach F,$(FILT),$(foreach Y,$(DS),$(eval $(call cobrarule,$(Y),$(F),_$(F),$(MT),${MTc},))))
$(foreach F,$(FILT),$(foreach Y,$(DSbulk),$(eval $(call cobrarule,$(Y),$(F),_$(F),$(MTbulk),${MTcbulk},_bulk))))

## ----------------------------- Calculate concordances ------------------------------- ##
## ------------------------------------------------------------------------------------ ##
define concrule
$(concordancedir)/$(1)$(3)_concordances.rds: scripts/calculate_concordances.R $(cobradir)/$(1)$(3)_cobra.rds scripts/concordance_functions.R
	$(R) "--args dataset='$(1)' filt='$(2)' cobradir='$(cobradir)' outdir='$(concordancedir)'" scripts/calculate_concordances.R Rout/calculate_concordances_$(1)$(3).Rout
endef
$(foreach Y,$(DS),$(eval $(call concrule,$(Y),,)))
$(foreach Y,$(DSbulk),$(eval $(call concrule,$(Y),,)))
$(foreach F,$(FILT),$(foreach Y,$(DS),$(eval $(call concrule,$(Y),$(F),_$(F)))))
$(foreach F,$(FILT),$(foreach Y,$(DSbulk),$(eval $(call concrule,$(Y),$(F),_$(F)))))

## ------------------------ Calculate relative performances --------------------------- ##
## ------------------------------------------------------------------------------------ ##
define relperfrule
$(relperfdir)/$(1)$(3)_relative_performance.rds: scripts/calculate_relative_performance_all_truths.R $(cobradir)/$(1)$(3)_cobra.rds
	$(R) "--args dataset='$(1)' filt='$(2)' cobradir='$(cobradir)' outdir='$(relperfdir)'" scripts/calculate_relative_performance_all_truths.R Rout/calculate_relative_performance_all_truths_$(1)$(3).Rout
endef
$(foreach Y,$(DS),$(eval $(call relperfrule,$(Y),,)))
$(foreach Y,$(DSbulk),$(eval $(call relperfrule,$(Y),,)))
$(foreach F,$(FILT),$(foreach Y,$(DS),$(eval $(call relperfrule,$(Y),$(F),_$(F)))))
$(foreach F,$(FILT),$(foreach Y,$(DSbulk),$(eval $(call relperfrule,$(Y),$(F),_$(F)))))

## -------------------------- Calculate true performances ----------------------------- ##
## ------------------------------------------------------------------------------------ ##
define trueperfrule
$(realperfdir)/$(1)$(3)_performance.rds: scripts/calculate_performance_realtruth.R $(cobradir)/$(1)$(3)_cobra.rds data/$(1)_truth.rds
	$(R) "--args dataset='$(1)' filt='$(2)' cobradir='$(cobradir)' outdir='$(realperfdir)'" scripts/calculate_performance_realtruth.R Rout/calculate_performance_realtruth_$(1)$(3).Rout
endef
$(foreach Y,$(DSsimsignal),$(eval $(call trueperfrule,$(Y),,)))
$(foreach F,$(FILT),$(foreach Y,$(DSsimsignal),$(eval $(call trueperfrule,$(Y),$(F),_$(F)))))

## --------------------------- Plots for evaluation ----------------------------------- ##
## ------------------------------------------------------------------------------------ ##
define plotrule
$(singledsfigdir)/$(2)/$(1)$(4)_$(2)_summary_data.rds: scripts/run_plot_single_dataset_evaluation.R scripts/plot_single_dataset_$(2).R scripts/plot_setup.R $(cobradir)/$(1)$(4)_cobra.rds
	$(R) "--args dataset='$(1)' filt='$(3)' plottype='$(2)' cobradir='$(cobradir)' concordancedir='$(concordancedir)' relperfdir='$(relperfdir)' realperfdir='$(realperfdir)' figdir='$(singledsfigdir)'" scripts/run_plot_single_dataset_evaluation.R Rout/run_plot_single_dataset_evaluation_$(1)$(4)_$(2).Rout
endef
$(foreach Y,$(DS),$(foreach P,$(PLOTTYPE1),$(eval $(call plotrule,$(Y),$(P),,))))
$(foreach Y,$(DSbulk),$(foreach P,$(PLOTTYPE1),$(eval $(call plotrule,$(Y),$(P),,))))
$(foreach F,$(FILT),$(foreach Y,$(DS),$(foreach P,$(PLOTTYPE1),$(eval $(call plotrule,$(Y),$(P),$(F),_$(F))))))
$(foreach F,$(FILT),$(foreach Y,$(DSbulk),$(foreach P,$(PLOTTYPE1),$(eval $(call plotrule,$(Y),$(P),$(F),_$(F))))))

define plotrule2
$(singledsfigdir)/$(2)/$(1)$(4)_$(2)_summary_data.rds: scripts/run_plot_single_dataset_evaluation.R scripts/plot_single_dataset_$(2).R scripts/plot_setup.R $(cobradir)/$(1)$(4)_cobra.rds \
$(concordancedir)/$(1)$(4)_concordances.rds scripts/help_function_crossmethod_concordance.R
	$(R) "--args dataset='$(1)' filt='$(3)' plottype='$(2)' cobradir='$(cobradir)' concordancedir='$(concordancedir)' relperfdir='$(relperfdir)' realperfdir='$(realperfdir)' figdir='$(singledsfigdir)'" scripts/run_plot_single_dataset_evaluation.R Rout/run_plot_single_dataset_evaluation_$(1)$(4)_$(2).Rout
endef
$(foreach Y,$(DS),$(foreach P,$(PLOTTYPE2),$(eval $(call plotrule2,$(Y),$(P),,))))
$(foreach Y,$(DSbulk),$(foreach P,$(PLOTTYPE2),$(eval $(call plotrule2,$(Y),$(P),,))))
$(foreach F,$(FILT),$(foreach Y,$(DS),$(foreach P,$(PLOTTYPE2),$(eval $(call plotrule2,$(Y),$(P),$(F),_$(F))))))
$(foreach F,$(FILT),$(foreach Y,$(DSbulk),$(foreach P,$(PLOTTYPE2),$(eval $(call plotrule2,$(Y),$(P),$(F),_$(F))))))

define plotrule3
$(singledsfigdir)/$(2)/$(1)$(4)_$(2)_summary_data.rds: scripts/run_plot_single_dataset_evaluation.R scripts/plot_single_dataset_$(2).R scripts/plot_setup.R \
$(relperfdir)/$(1)$(4)_relative_performance.rds
	$(R) "--args dataset='$(1)' filt='$(3)' plottype='$(2)' cobradir='$(cobradir)' concordancedir='$(concordancedir)' relperfdir='$(relperfdir)' realperfdir='$(realperfdir)' figdir='$(singledsfigdir)'" scripts/run_plot_single_dataset_evaluation.R Rout/run_plot_single_dataset_evaluation_$(1)$(4)_$(2).Rout
endef
$(foreach Y,$(DS),$(foreach P,$(PLOTTYPE3),$(eval $(call plotrule3,$(Y),$(P),,))))
$(foreach Y,$(DSbulk),$(foreach P,$(PLOTTYPE3),$(eval $(call plotrule3,$(Y),$(P),,))))
$(foreach F,$(FILT),$(foreach Y,$(DS),$(foreach P,$(PLOTTYPE3),$(eval $(call plotrule3,$(Y),$(P),$(F),_$(F))))))
$(foreach F,$(FILT),$(foreach Y,$(DSbulk),$(foreach P,$(PLOTTYPE3),$(eval $(call plotrule3,$(Y),$(P),$(F),_$(F))))))

define plotrule4
$(singledsfigdir)/$(2)/$(1)$(4)_$(2)_summary_data.rds: scripts/run_plot_single_dataset_evaluation.R scripts/plot_single_dataset_$(2).R scripts/plot_setup.R \
$(realperfdir)/$(1)$(4)_performance.rds
	$(R) "--args dataset='$(1)' filt='$(3)' plottype='$(2)' cobradir='$(cobradir)' concordancedir='$(concordancedir)' relperfdir='$(relperfdir)' realperfdir='$(realperfdir)' figdir='$(singledsfigdir)'" scripts/run_plot_single_dataset_evaluation.R Rout/run_plot_single_dataset_evaluation_$(1)$(4)_$(2).Rout
endef
$(foreach Y,$(DSsimsignal),$(foreach P,$(PLOTTYPE4),$(eval $(call plotrule4,$(Y),$(P),,))))
$(foreach F,$(FILT),$(foreach Y,$(DSsimsignal),$(foreach P,$(PLOTTYPE4),$(eval $(call plotrule4,$(Y),$(P),$(F),_$(F))))))

## -------------------- Plots for characterization of data set ------------------------ ##
## ------------------------------------------------------------------------------------ ##
define plotrule_characterization
$(dschardir)/$(1)$(3)_dataset_characteristics_summary_data.rds: scripts/run_plot_dataset_characterization.R scripts/prepare_mae.R \
subsets/$(1)_subsets.rds data/$(1).rds scripts/calculate_gene_characteristics.R  scripts/calculate_cell_characteristics.R
	$(R) "--args dataset='$(1)' config_file='config/$(1).json' filt='$(2)' cell_cycle_file='data/cell_cycle_geneids.rds' figdir='$(dschardir)'" scripts/run_plot_dataset_characterization.R Rout/run_plot_dataset_characterization_$(1)$(3).Rout
endef
$(foreach Y,$(DS),$(eval $(call plotrule_characterization,$(Y),,)))
$(foreach Y,$(DSbulk),$(eval $(call plotrule_characterization,$(Y),,)))
$(foreach F,$(FILT), $(foreach Y,$(DS),$(eval $(call plotrule_characterization,$(Y),$(F),_$(F)))))
$(foreach F,$(FILT), $(foreach Y,$(DSbulk),$(eval $(call plotrule_characterization,$(Y),$(F),_$(F)))))

## -------------------- Plots for evaluation, orig vs mock ---------------------------- ##
## ------------------------------------------------------------------------------------ ##
define origvsmockrule
$(figdir)/orig_vs_mock/$(1)$(3)_orig_vs_mock_summary_data.rds: $(concordancedir)/$(1)$(3)_concordances.rds \
$(concordancedir)/$(1)mock$(3)_concordances.rds scripts/plot_setup.R  \
scripts/run_plot_single_dataset_origvsmock.R scripts/plot_single_dataset_origvsmock.R
	$(R) "--args dataset='$(1)' filt='$(2)' concordancedir='$(concordancedir)' figdir='$(figdir)/orig_vs_mock'" scripts/run_plot_single_dataset_origvsmock.R Rout/run_plot_single_dataset_origvsmock_$(1)$(3).Rout
endef
$(foreach Y,$(Dsb),$(eval $(call origvsmockrule,$(Y),,)))
$(foreach Y,$(DSbulksignal),$(eval $(call origvsmockrule,$(Y),,)))
$(foreach Y,$(Dsbsim),$(eval $(call origvsmockrule,$(Y),,)))
$(foreach F,$(FILT), $(foreach Y,$(Dsb),$(eval $(call origvsmockrule,$(Y),$(F),_$(F)))))
$(foreach F,$(FILT), $(foreach Y,$(DSbulksignal),$(eval $(call origvsmockrule,$(Y),$(F),_$(F)))))
$(foreach F,$(FILT), $(foreach Y,$(Dsbsim),$(eval $(call origvsmockrule,$(Y),$(F),_$(F)))))

## ------------------------ Summary plots, across data sets --------------------------- ##
## ------------------------------------------------------------------------------------ ##
define summaryrule_timing
$(multidsfigdir)/timing/summary_timing$(1).rds: $(addsuffix _summary_data.rds, $(addprefix $(singledsfigdir)/timing/, $(foreach Y,$(2),$(Y)_timing))) \
$(addsuffix _summary_data.rds, $(addprefix $(singledsfigdir)/timing/, $(foreach F,$(4),$(foreach Y,$(2),$(Y)_$(F)_timing)))) \
scripts/run_plot_multi_dataset_summarization.R scripts/summarize_timing.R include_datasets.mk include_filterings.mk scripts/plot_setup.R
	$(R) "--args datasets='$(3)' filt='$(5)' summarytype='timing' dtpext='$(1)' figdir='$(multidsfigdir)/timing' singledsfigdir='$(singledsfigdir)' cobradir='$(cobradir)' dschardir='$(dschardir)' origvsmockdir='$(figdir)/orig_vs_mock' concordancedir='$(concordancedir)'" scripts/run_plot_multi_dataset_summarization.R Rout/run_plot_multi_dataset_summarization_timing$(1).Rout
endef
$(eval $(call summaryrule_timing,_all,$(DS),${DSc},$(FILT),${FILTc}))

define summaryrule_fracNA
$(multidsfigdir)/fracNA/summary_fracNA$(1).rds: $(addsuffix _cobra.rds, $(addprefix $(cobradir)/, $(foreach Y,$(2),$(Y)))) \
$(addsuffix _cobra.rds, $(addprefix $(cobradir)/, $(foreach F,$(4),$(foreach Y,$(2),$(Y)_$(F))))) \
scripts/run_plot_multi_dataset_summarization.R scripts/summarize_fracNA.R include_datasets.mk include_filterings.mk scripts/plot_setup.R
	$(R) "--args datasets='$(3)' filt='$(5)' summarytype='fracNA' dtpext='$(1)' figdir='$(multidsfigdir)/fracNA' singledsfigdir='$(singledsfigdir)' cobradir='$(cobradir)' dschardir='$(dschardir)' origvsmockdir='$(figdir)/orig_vs_mock' concordancedir='$(concordancedir)'" scripts/run_plot_multi_dataset_summarization.R Rout/run_plot_multi_dataset_summarization_fracNA$(1).Rout
endef
$(eval $(call summaryrule_fracNA,_real,$(DSreal),${DSrealc},$(FILT),${FILTc}))
$(eval $(call summaryrule_fracNA,_bulk,$(DSbulk),${DSbulkc},$(FILT),${FILTc}))

define summaryrule_nbrdet
$(multidsfigdir)/nbrdet/summary_nbrdet$(1).rds: $(addsuffix _cobra.rds, $(addprefix $(cobradir)/, $(foreach Y,$(2),$(Y)))) \
$(addsuffix _cobra.rds, $(addprefix $(cobradir)/, $(foreach F,$(4),$(foreach Y,$(2),$(Y)_$(F))))) \
scripts/run_plot_multi_dataset_summarization.R scripts/summarize_nbrdet.R include_datasets.mk include_filterings.mk scripts/plot_setup.R
	$(R) "--args datasets='$(3)' filt='$(5)' summarytype='nbrdet' dtpext='$(1)' figdir='$(multidsfigdir)/nbrdet' singledsfigdir='$(singledsfigdir)' cobradir='$(cobradir)' dschardir='$(dschardir)' origvsmockdir='$(figdir)/orig_vs_mock' concordancedir='$(concordancedir)'" scripts/run_plot_multi_dataset_summarization.R Rout/run_plot_multi_dataset_summarization_nbrdet$(1).Rout
endef
$(eval $(call summaryrule_nbrdet,_real,$(DSrealsignal),${DSrealsignalc},$(FILT),${FILTc}))
$(eval $(call summaryrule_nbrdet,_bulk,$(DSbulksignal),${DSbulksignalc},$(FILT),${FILTc}))

define summaryrule_truefpr
$(multidsfigdir)/truefpr/summary_truefpr$(1).rds: $(addsuffix _summary_data.rds, $(addprefix $(singledsfigdir)/truefpr/, $(foreach Y,$(2),$(Y)_truefpr))) \
$(addsuffix _summary_data.rds, $(addprefix $(singledsfigdir)/truefpr/, $(foreach F,$(4),$(foreach Y,$(2),$(Y)_$(F)_truefpr)))) \
scripts/run_plot_multi_dataset_summarization.R scripts/summarize_truefpr.R include_datasets.mk include_filterings.mk scripts/plot_setup.R
	$(R) "--args datasets='$(3)' filt='$(5)' summarytype='truefpr' dtpext='$(1)' figdir='$(multidsfigdir)/truefpr' singledsfigdir='$(singledsfigdir)' cobradir='$(cobradir)' dschardir='$(dschardir)' origvsmockdir='$(figdir)/orig_vs_mock' concordancedir='$(concordancedir)'" scripts/run_plot_multi_dataset_summarization.R Rout/run_plot_multi_dataset_summarization_truefpr$(1).Rout
endef
$(eval $(call summaryrule_truefpr,_real,$(DSrealmock),${DSrealmockc},$(FILT),${FILTc}))
$(eval $(call summaryrule_truefpr,_sim,$(DSsimmock),${DSsimmockc},$(FILT),${FILTc}))
$(eval $(call summaryrule_truefpr,_bulk,$(DSbulkmock),${DSbulkmockc},$(FILT),${FILTc}))

define summaryrule_de_characteristics
$(multidsfigdir)/de_characteristics/summary_de_characteristics$(1).rds: $(addsuffix _summary_data.rds, $(addprefix $(singledsfigdir)/results_characterization/, $(foreach Y,$(2),$(Y)_results_characterization))) \
scripts/run_plot_multi_dataset_summarization.R scripts/summarize_de_characteristics.R include_datasets.mk include_filterings.mk scripts/plot_setup.R
	$(R) "--args datasets='$(3)' filt='$(5)' summarytype='de_characteristics' dtpext='$(1)' figdir='$(multidsfigdir)/de_characteristics' singledsfigdir='$(singledsfigdir)' cobradir='$(cobradir)' dschardir='$(dschardir)' origvsmockdir='$(figdir)/orig_vs_mock' concordancedir='$(concordancedir)'" scripts/run_plot_multi_dataset_summarization.R Rout/run_plot_multi_dataset_summarization_de_characteristics$(1).Rout
endef
$(eval $(call summaryrule_de_characteristics,_real,$(DSrealmock),${DSrealmockc},,))
$(eval $(call summaryrule_de_characteristics,_sim,$(DSsimmock),${DSsimmockc},,))

define summaryrule_crossmethod_consistency
$(multidsfigdir)/crossmethod_consistency/summary_crossmethod_consistency$(1).rds: $(addsuffix .rds, $(addprefix $(concordancedir)/, $(foreach Y,$(2),$(Y)_concordances))) \
$(addsuffix .rds, $(addprefix $(concordancedir)/, $(foreach F,$(4),$(foreach Y,$(2),$(Y)_$(F)_concordances)))) \
scripts/run_plot_multi_dataset_summarization.R scripts/summarize_crossmethod_consistency.R scripts/help_function_crossmethod_concordance.R \
include_datasets.mk include_filterings.mk scripts/plot_setup.R
	$(R) "--args datasets='$(3)' filt='$(5)' summarytype='crossmethod_consistency' dtpext='$(1)' figdir='$(multidsfigdir)/crossmethod_consistency' singledsfigdir='$(singledsfigdir)' cobradir='$(cobradir)' dschardir='$(dschardir)' origvsmockdir='$(figdir)/orig_vs_mock' concordancedir='$(concordancedir)'" scripts/run_plot_multi_dataset_summarization.R Rout/run_plot_multi_dataset_summarization_crossmethod_consistency$(1).Rout
endef
$(eval $(call summaryrule_crossmethod_consistency,_real,$(DSrealsignal),${DSrealsignalc},$(FILT),${FILTc}))
$(eval $(call summaryrule_crossmethod_consistency,_sim,$(DSsimsignal),${DSsimsignalc},$(FILT),${FILTc}))
$(eval $(call summaryrule_crossmethod_consistency,_bulk,$(DSbulksignal),${DSbulksignalc},$(FILT),${FILTc}))

define summaryrule_relfprtpr
$(multidsfigdir)/relfprtpr/summary_relfprtpr$(1).rds: $(addsuffix _summary_data.rds, $(addprefix $(singledsfigdir)/results_relativetruth/, $(foreach Y,$(2),$(Y)_results_relativetruth))) \
$(addsuffix _summary_data.rds, $(addprefix $(singledsfigdir)/results_relativetruth/, $(foreach F,$(4),$(foreach Y,$(2),$(Y)_$(F)_results_relativetruth)))) \
scripts/run_plot_multi_dataset_summarization.R scripts/summarize_relfprtpr.R include_datasets.mk include_filterings.mk scripts/plot_setup.R
	$(R) "--args datasets='$(3)' filt='$(5)' summarytype='relfprtpr' dtpext='$(1)' figdir='$(multidsfigdir)/relfprtpr' singledsfigdir='$(singledsfigdir)' cobradir='$(cobradir)' dschardir='$(dschardir)' origvsmockdir='$(figdir)/orig_vs_mock' concordancedir='$(concordancedir)'" scripts/run_plot_multi_dataset_summarization.R Rout/run_plot_multi_dataset_summarization_relfprtpr$(1).Rout
endef
$(eval $(call summaryrule_relfprtpr,_real,$(DSrealsignal),${DSrealsignalc},$(FILT),${FILTc}))
$(eval $(call summaryrule_relfprtpr,_sim,$(DSsimsignal),${DSsimsignalc},$(FILT),${FILTc}))

define summaryrule_filtering
$(multidsfigdir)/filtering/summary_filtering_$(1)$(2).rds: $(addsuffix _cobra.rds, $(addprefix $(cobradir)/, $(foreach Y,$(3),$(Y)_$(1)))) \
$(addsuffix _cobra.rds, $(addprefix $(cobradir)/, $(foreach Y,$(3),$(Y)))) scripts/run_plot_multi_dataset_summarization.R scripts/summarize_filtering.R \
include_datasets.mk include_filterings.mk $(addsuffix _dataset_characteristics_summary_data.rds, $(addprefix $(dschardir)/, $(foreach Y,$(3),$(Y)))) scripts/plot_setup.R
	$(R) "--args datasets='$(4)' filt='$(1)' summarytype='filtering' dtpext='$(2)' figdir='$(multidsfigdir)/filtering' singledsfigdir='$(singledsfigdir)' cobradir='$(cobradir)' dschardir='$(dschardir)' origvsmockdir='$(figdir)/orig_vs_mock' concordancedir='$(concordancedir)'" scripts/run_plot_multi_dataset_summarization.R Rout/run_plot_multi_dataset_summarization_filtering_$(1)$(2).Rout
endef
$(foreach F,$(FILT),$(eval $(call summaryrule_filtering,$(F),_real,$(DSrealsignal),${DSrealsignalc})))
$(foreach F,$(FILT),$(eval $(call summaryrule_filtering,$(F),_bulk,$(DSbulksignal),${DSbulksignal})))
$(foreach F,$(FILT),$(eval $(call summaryrule_filtering,$(F),_sim,$(DSsimsignal),${DSsimsignalc})))

define summaryrule_trueperformance
$(multidsfigdir)/trueperformance/summary_trueperformance$(1).rds: $(addsuffix _summary_data.rds, $(addprefix $(singledsfigdir)/performance_realtruth/, $(foreach Y,$(2),$(Y)_performance_realtruth))) \
$(addsuffix _summary_data.rds, $(addprefix $(singledsfigdir)/performance_realtruth/, $(foreach F,$(4),$(foreach Y,$(2),$(Y)_$(F)_performance_realtruth)))) \
scripts/run_plot_multi_dataset_summarization.R scripts/summarize_trueperformance.R include_datasets.mk include_filterings.mk scripts/plot_setup.R
	$(R) "--args datasets='$(3)' filt='$(5)' summarytype='trueperformance' dtpext='$(1)' figdir='$(multidsfigdir)/trueperformance' singledsfigdir='$(singledsfigdir)' cobradir='$(cobradir)' dschardir='$(dschardir)' origvsmockdir='$(figdir)/orig_vs_mock' concordancedir='$(concordancedir)'" scripts/run_plot_multi_dataset_summarization.R Rout/run_plot_multi_dataset_summarization_trueperformance$(1).Rout
endef
$(eval $(call summaryrule_trueperformance,_sim,$(DSsimsignal),${DSsimsignalc},$(FILT),${FILTc}))

define summaryrule_origvsmock
$(multidsfigdir)/orig_vs_mock/summary_orig_vs_mock$(1).rds: $(addsuffix _orig_vs_mock_summary_data.rds, $(addprefix $(figdir)/orig_vs_mock/, $(foreach Y,$(2),$(Y)))) \
$(addsuffix _orig_vs_mock_summary_data.rds, $(addprefix $(figdir)/orig_vs_mock/, $(foreach F,$(4),$(foreach Y,$(2),$(Y)_$(F))))) \
scripts/run_plot_multi_dataset_summarization.R scripts/summarize_orig_vs_mock.R include_datasets.mk include_filterings.mk scripts/plot_setup.R
	$(R) "--args datasets='$(3)' filt='$(5)' summarytype='orig_vs_mock' dtpext='$(1)' figdir='$(multidsfigdir)/orig_vs_mock' singledsfigdir='$(singledsfigdir)' cobradir='$(cobradir)' dschardir='$(dschardir)' origvsmockdir='$(figdir)/orig_vs_mock' concordancedir='$(concordancedir)'" scripts/run_plot_multi_dataset_summarization.R Rout/run_plot_multi_dataset_summarization_orig_vs_mock$(1).Rout
endef
$(eval $(call summaryrule_origvsmock,_real,$(Dsb),${Dsbc},$(FILT),${FILTc}))
$(eval $(call summaryrule_origvsmock,_sim,$(Dsbsim),${Dsbsimc},$(FILT),${FILTc}))
$(eval $(call summaryrule_origvsmock,_bulk,$(DSbulksignal),${DSbulksignalc},$(FILT),${FILTc}))

define summaryrule_tsne
$(multidsfigdir)/tsne/summary_tsne$(1).rds: $(addsuffix _dataset_characteristics_plots.rds, $(addprefix $(dschardir)/, $(foreach Y,$(2),$(Y)))) \
scripts/run_plot_multi_dataset_summarization.R scripts/summarize_tsne.R include_datasets.mk scripts/plot_setup.R
	$(R) "--args datasets='$(3)' filt='$(4)' summarytype='tsne' dtpext='$(1)' figdir='$(multidsfigdir)/tsne' singledsfigdir='$(singledsfigdir)' cobradir='$(cobradir)' dschardir='$(dschardir)' origvsmockdir='$(figdir)/orig_vs_mock' concordancedir='$(concordancedir)'" scripts/run_plot_multi_dataset_summarization.R Rout/run_plot_multi_dataset_summarization_tsne$(1).Rout
endef
$(eval $(call summaryrule_tsne,_all,$(DStsne),${DStsnec},))

define summaryrule_dschar
$(multidsfigdir)/ds_characteristics/summary_ds_characteristics$(1).rds: $(addsuffix _dataset_characteristics_summary_data.rds, $(addprefix $(dschardir)/, $(foreach Y,$(2),$(Y)))) \
scripts/run_plot_multi_dataset_summarization.R scripts/summarize_ds_characteristics.R include_datasets.mk scripts/plot_setup.R
	$(R) "--args datasets='$(3)' filt='$(4)' summarytype='ds_characteristics' dtpext='$(1)' figdir='$(multidsfigdir)/ds_characteristics' singledsfigdir='$(singledsfigdir)' cobradir='$(cobradir)' dschardir='$(dschardir)' origvsmockdir='$(figdir)/orig_vs_mock' concordancedir='$(concordancedir)'" scripts/run_plot_multi_dataset_summarization.R Rout/run_plot_multi_dataset_summarization_ds_characteristics$(1).Rout
endef
$(eval $(call summaryrule_dschar,_real,$(DSrealsignal),${DSrealsignalc},))

## --------------------- Investigation of voom/limma behaviour ------------------------ ##
## ------------------------------------------------------------------------------------ ##
figures/misc/voomlimma_investigation.rds: $(addsuffix _subsets.rds, $(addprefix subsets/, $(foreach D,$(DSrealmock),$(D)))) \
$(addsuffix .rds, $(addprefix data/, $(foreach D,$(DSrealmock),$(D)))) scripts/investigate_voomlimma_results.R
	$(R) "--args figdir='figures/misc'" scripts/investigate_voomlimma_results.R Rout/investigate_voomlimma_results.Rout


