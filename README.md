

This is a Quarto website which captures multiple lines of Environment Agency water management evidence.
You will find 6 .qmd pages which form the website.

File structure of Repo:
```
├── _quarto.yml              # Project configuration (multi-page site)
├── index.qmd                # Main homepage
├── Overview.qmd             # page on surface water and groundwater catchment boundries, catchment topography, geology, bathing waters etc.
├── Ecology.qmd              # page on WFD biological classification elements, each in detail (fish, macrophytes, macroinvertebrates).
├── Water_Quality.qmd                # page on WFD biological classification elements, each in detail (fish, macrophytes, macroinvertebrates).
├── Physical_Habitat.qmd                # page on 
├── Water_Resources.qmd                # Additional page 2
├── scripts                
│   └── Catch_Set_Up.R        # Determines WFD catchment to be rendered in each .qmd page above
│   └── WIMS_Transform_Script.R  # Transforms WIMS data to match catchment of choice.
├── styles/
│   └── styles.css         # Custom CSS
```
