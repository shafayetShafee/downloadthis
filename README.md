# Downloadthis Extension For Quarto

This extension shortcode provides support for adding download buttons in the html files with attached small image/pdf/txt/csv files using shortcode `{{< downloadthis >}}`.

[View Live Demo](https://shafayetshafee.github.io/downloadthis/example.html)

## Installing

```bash
quarto add shafayetShafee/downloadthis
```

This will install the extension under the `_extensions` subdirectory.
If you're using version control, you will want to check in this directory.

## Using

To embed a file downloadable from the rendered html document, use the `{{< downloadthis >}}` shortcode. For example, 

```
{{< downloadthis image.png >}}
```

would create a download button [styled with bootstrap](https://getbootstrap.com/docs/5.3/components/buttons/#examples) with which `file.png` can be downloaded.


### Options

There are six additional arguments you can specify for this shortcode, which are,

- **`dname`** : The filename (without file extension!) which will be assigned to the downloaded file (default value is `file`)
- **`label`** : Button label (default is `Download`).
- **`icon`**: [Bootstrap Icon](https://icons.getbootstrap.com/) for the button (default is [`download`](https://icons.getbootstrap.com/icons/download/)).
- **`type`**: [Bootstrap button styles](https://getbootstrap.com/docs/5.3/components/buttons/#examples), which are `primary`, `secondary`, `success`, `warning`, `danger`, `info`, `light`, `dark`,
`light` (default value is `default`).
- **`class`**: CSS class to be assigned to this button.
- **`id`**: CSS id to be assigned to this button.

An example using all these arguments as follows,

```
{{< downloadthis files/mtcars.csv dname="mtcars.csv" label="Download the mtcars data" icon="database-fill-down" type="info" >}}
```
where `mtcars.csv` is in a folder named `files` and the `files` folder is in the same folder with source `.qmd` file.

## Example

Here is the source code for examples: [example.qmd](example.qmd) and the rendered html output: [example.html](https://shafayetshafee.github.io/downloadthis/example.html)