# StreamDeck-Builder

Hello, welcome to the StreamDeckBuilder.

The **StreamDeckBuilder** is a tool written in powershell that convert a YAML structure to a CSV file. With this you can have a "streamdeck feeling" using a combination of links and icons.

## StreamDeck  

Streamdecks are hardware that are mainly used by streamers, its a panel that has a lot of buttons, where each button is a trigger for something example:
* Any famous Meme sound
* Piece of music
* Changing overlay screens

In reusme just a collection of actions that are visible by big buttons and acessible at the same time. 

## Acessible and Visible 

Well if you are a developer you know that you have to remember a lot of links, and so  newcomers can join and we should explain that, and if you are growing up in microservices archtecture maybe you have a lot more actions than a usual application has.

This is where we can try use ideas inspired by Streamdeck to just be a place where we can focus on **visible** and **acessible**.

### Example of streamdeck for this project


- **Services**

|Git                                                          |PoweredBy                                                                                              |Lang                                                                                                      |
|-------------------------------------------------------------|-------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------|
|[![Git_icon.svg](https://lkobus.github.io/markdown-streamdeck/res//Git_icon.svg)](https://github.com/lkobus/markdown-streamdeck "Source Repository")|~Dashman                                                                                               |![powershell-icon.svg](https://lkobus.github.io/markdown-streamdeck/res//powershell-icon.svg "Powershell")|
|[![Git_icon.svg](https://lkobus.github.io/markdown-streamdeck/res//Git_icon.svg)](https://github.com/lkobus/markdown-streamdeck "Source Repository")|~Dashman                                                                                               |![powershell-icon.svg](https://lkobus.github.io/markdown-streamdeck/res//powershell-icon.svg "Powershell")|



---

- **Libs**

|Lang                                                         |Name                                                                                                   |Git                                                                                                       |
|-------------------------------------------------------------|-------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------|
|![powershell-icon.svg](https://lkobus.github.io/markdown-streamdeck/res//powershell-icon.svg "Powershell")|powershell-yaml                                                                                        |[![Git_icon.svg](https://lkobus.github.io/markdown-streamdeck/res//Git_icon.svg)](https://github.com/cloudbase/powershell-yaml "Source Repository")|


---

## How can I Build My own?

This script was tested using Windows 10, but i think it can rune fine in Ubuntu too.

0. **Install the powershell-yaml dependency.**
```ps
Install-Module powershell-yaml
```

1. **First Download the script**

```ps
git clone https://github.com/lkobus/markdown-streamdeck.git .
```
2. **Prepare your Yaml File**

You can start with the example that exist in the repository named "micro_services.yaml" in the repository to get started
```yaml
Services:
  - streamdeck-builder:
      Lang:        
        IconUriPath: 'https://lkobus.github.io/markdown-streamdeck/res/'
        IconFileName: 'powershell-icon.svg'
        Tooltip: "Powershell"      
      Git:
        ColumnPosition: 1
        IconUriPath: "https://lkobus.github.io/markdown-streamdeck/res/"
        IconFileName: 'Git_icon.svg'
        Tooltip: "Source Repository"
        Hyperlink: "https://github.com/lkobus/markdown-streamdeck"
      PoweredBy:       
        ColumnPosition: 2
        Description: "~Dashman"  
Libs:
  - powershell-yaml:
      Lang:
        IconUriPath: 'https://lkobus.github.io/markdown-streamdeck/res/'
        IconFileName: 'powershell-icon.svg'
        Tooltip: "Powershell"       
      Git:      
        IconUriPath: "https://lkobus.github.io/markdown-streamdeck/res/"
        IconFileName: 'Git_icon.svg'
        Tooltip: "Source Repository"
        Hyperlink: "https://github.com/cloudbase/powershell-yaml"
      Name:
        Description: "powershell-yaml"
      
      
```
~*micro_services.yaml File*


3. **For generating the output you should run**

```ps1
$script_dir> .\StreamDeck-Builder.ps1 -yamlInput .\micro_services.yaml -outputCsv .\out.md
```

> This will create two tables "out.md" for the "Services" and "out-libs.md" for the Libs.



4. **Just copy and paste the generated markdowns in your .md**

![usage-in-this-site.png](https://lkobus.github.io/markdown-streamdeck/res/usage-in-this-site.png)

---


## Yaml Structure 
**The yaml structure can have the follow root attributes**
```yaml
Services:
    - CellItem:
    ...
Libs:
    - CellItem:
    ...
Jobs:
    - CellItem:
    ...
```

And the supported types inside CellItem are:
```yaml
Libs:
  - powershell-yaml:
      Lang: #When you have a icon without hyperlink
        IconUriPath: 'https://lkobus.github.io/markdown-streamdeck/res/' 
        IconFileName: 'powershell-icon.svg'
        Tooltip: "Powershell"       
      Git:      
        #When you have a icon with hyperlink
        IconUriPath: "https://lkobus.github.io/markdown-streamdeck/res/"
        IconFileName: 'Git_icon.svg'
        Tooltip: "Source Repository"
        Hyperlink: "https://github.com/cloudbase/powershell-yaml"
        
      Name:
        #When you just have a label
        Description: "powershell-yaml"
```

### About Columns Position
Columns position is setted in ColumnPosition Attribute inside each CellItem. If two columns have the same position, the last one will overwrite, if no columns is specified it will be randomed inserted.
```yaml
ColumnPosition: 1
```

> Remember this is a table parsed yaml, so all cell items should have the same ammount of properties, remember each child of Cellitem is a property that reflects a icon, link or text.

### Global IconUriPath
If you dont wanna specify IconUriPath all the time you can use the global version to just set one time like this example in the root of the document: 
```yaml
IconUriPath: 'https://lkobus.github.io/markdown-streamdeck/res/' 
Services:
  - streamdeck-builder:
      Lang:                
        IconFileName: 'powershell-icon.svg'
        Tooltip: "Powershell"      
Libs:
    - CellItem
    ...
```
*If IconUriPath is missing in CellItem it will look for the global property.*

### Contact?

- Fell free to contribute, and if you wanna get in touch reach me in [linkedin](https://www.linkedin.com/in/leonardo-kobus-73125857/)

### Final considerations
- Maybe for you run the powershell you should give a permission to "unsigned script". 
- I recommend you just read the powershell script always to see if you are not using a wrong version, that someone can modify.
- I recommend use icons in .svg and that you make a "standard" resolution
  - In this page all the icons are configured to: 
  ```html  
  <svg width="42px" height="42"...
  ```
- This site uses github web_page enabled to export the png files to link the resources in this markdown.

