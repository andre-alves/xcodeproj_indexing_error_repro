# xcodeproj_indexing_error_repro

Repro project showing errors in background indexer

How to reproduce:

- `bazelisk run //BazelSample:BazelSampleXcodeProj`
- `open BazelSample/BazelSample.xcodeproj`
- Do nothing, just wait for all `Index Build` tasks to finish.
- When BazelSample is `Ready`, open `DrinkDiscoveryInteractor.swift`
- Check the background indexing logs.
