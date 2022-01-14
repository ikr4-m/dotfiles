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

# Add package
dotnet add package <NuGetPackage>

# List package
dotnet list package

# Remove package
dotnet remove package <NuGetPackage>
```

## Running App
```bash
# Run csproj
dotnet run
dotnet run -p path\to\csproj.csproj

# Run csproj without compiling
dotnet run --no-build

# Run test build
dotnet test

# Run watcher
dotnet watch -- run
dotnet watch -- run -p path\to\csproj.csproj
```

## Managing Project
```bash
# Add csproj to sln
dotnet sln add path\to\csproj.csproj

# Restore sln
dotnet restore                      # Execute in sln folder

# Build sln
dotnet build sln.sln
```
