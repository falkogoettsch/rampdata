# RAMPDATA

Reads RAMP project data from an archive.

## Installation

Install the 7zip tool by hand.

```R
devtools::install_github("jimhester/archive")
```

## Usage

Under the hood, paths are assembled by the `ramp_path` function which returns a relative path which can be appended to a root path to generate the full path to the data.

```R
ramp_path <- function(stage, location, project, user, rproject, path = NULL)
```

The root path can be specified in one of the following configuration files:

```Shell
${XDG_CONFIG_HOME}/RAMP/data.ini
$HOME/.config/RAMP/data.ini
$HOME/.ramp.ini
```

#### Valid combinations of parameters and their mapping to paths

---
*Note:*

`[]` _indicate optional parameters_
`|` _indicates a list of possible parameters_

The parameters `location` and `path` are appended to the end of the path and are always optional. If both are specified, `location` is appended first.

```Shell
<assembled path>/locations/<location>
<assembled path>/<path>
<assembled path>/locations/<location>/<path>
```
---

**input|output [location] project [user] [path (default: NULL)]** <sup>1</sup>

```Shell
projects/<project>/<inputs>
projects/<project>/<inputs>/users/<user>
projects/<project>/<outputs>
projects/<project>/<outputs>/users/<user>
```

**working [location] project user [path (default: NULL)]**

```Shell
projects/<project>/users/<user>
```

**input|output|working [location] rproject [user] [path (default: NULL)]** <sup>2</sup>

```Shell
libraries/<rproject>/inst/extdata
libraries/<rproject>/inst/extdata/users/<user>
```

**input [location] [user] [path (default: NULL)]** <sup>3</sup>

```Shell
inputs
inputs/users/<user>
```

**output|working [location] user [path (default: NULL)]**

```Shell
outputs/users/<user>
working/users/<user>
```

<sup>1</sup> `user` is optional but ignored\
<sup>2</sup> `input|output|working` is required but ignored\
<sup>3</sup> `user` is optional but ignored

## Credits

Ramp image from https://www.flickr.com/photos/chrisfurniss/.
