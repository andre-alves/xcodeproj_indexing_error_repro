.PHONY : build clean clean_bazel bazelsample

BAZEL = bazelisk

bazelsample:
	$(BAZEL) run //BazelSample:BazelSampleXcodeProj
	open BazelSample/BazelSample.xcodeproj

clean_bazel:
	$(BAZEL) clean --expunge

clean:
	rm -rf BazelSample/BazelSample.xcodeproj/
	rm -rf ~/Library/Developer/Xcode/DerivedData
