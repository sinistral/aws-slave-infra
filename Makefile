
artifact-dir        := out

templates           := $(shell find . -name \*.yaml -and -not -name \*buildspec\* -and -not -path \*/out/\*)
validated-templates := $(patsubst %, $(artifact-dir)/validated/%, $(templates))
buildvars-tmpfile   := $(substrate)/buildvars-local-tmp.env

AWS_REGION          ?= eu-central-1

.DEFAULT_GOAL       := codebuild-local-build

.INTERMEDIATE: $(buildvars-tmpfile)


### ------------------------------------------------------------------------ ###

.PHONY: clean validate

clean:
	rm -rf $(artifact-dir)

$(artifact-dir)/validated/%.yaml: %.yaml
	mkdir -p $(@D)
	aws --region ${AWS_REGION} \
		cloudformation validate-template \
		--template-body file://$<
	touch $@

validate: $(validated-templates)

.PHONY: %-stack %-stack-update-change-set

%-stack:
	aws --region ${AWS_REGION} \
		cloudformation create-stack \
		--capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM \
		--disable-rollback \
		--parameters $(stack-parameters) \
		--stack-name $* \
		--template-body file://$*/template/$*.yaml

%-stack-update-change-set:
	aws --region ${AWS_REGION} \
		cloudformation create-change-set \
		--capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM \
		--change-set-name ${USER}-$(shell date -ju +"%Y%m%dT%H%M%S") \
		--change-set-type UPDATE \
		--parameters $(stack-parameters) \
		--stack-name $* \
		--template-body file://$*/template/$*.yaml
