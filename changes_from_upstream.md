- `source/stylesheets/custom_appium.css` added to `source/layout.erb` using

```
<%= stylesheet_link_tag "custom_appium" %>
```

- New Rakefile
- Replaced `source/images/logo.png` with [appium-logo-white](https://github.com/appium/appium.io/blob/gh-pages/img/appium-logo-white.png)

### Notes

- `rake publish` - Publish source/index.md to gh-pages branch
- `rake build` - Compile all files into the build directory
- `rake md` - Merge markdown files
- `middleman server` - Run local instance of the docs