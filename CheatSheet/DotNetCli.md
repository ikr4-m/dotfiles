https://docs.microsoft.com/en-us/dotnet/core/tools/

## CSProj Config
https://docs.microsoft.com/en-us/visualstudio/msbuild/itemgroup-element-msbuild

## Making Project
```bash
# List template
dotnet new --list

# Make new project
dotnet new sln -o <ProjName>        # Make SLN
dotnet new console -o <ProjName>    # Make console app

# Add CS Project to SLN
dotnet sln <SLNFile> add path\to\file.csproj
```

## Running App
```bash
# Run csproj
dotnet run
dotnet run --project path\to\csproj.csproj

# Release csproj
dotnet build -c Release

# Run test build
dotnet test

# Run watcher
dotnet watch -- run
dotnet watch -- run -p path\to\csproj.csproj
```

## Managing Project
```bash
# Restore sln
dotnet restore                      # Execute in sln folder

# Add package
dotnet add package <NuGetPackage>

# List package
dotnet list package

# Remove package
dotnet remove package <NuGetPackage>

# Add P2P Reference
dotnet add reference path\to\csproj.csproj
```
