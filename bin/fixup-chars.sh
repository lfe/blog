#!/usr/bin/env bash

# fix up XML files
find . -type f -name "*.xml" -exec sed -i "" "s/&amp;#8211;;/--/g" {} +
find . -type f -name "*.xml" -exec sed -i "" "s/&amp;#8230/.../g" {} +
find . -type f -name "*.xml" -exec sed -i "" "s/&amp;#8216;/'/g" {} +
find . -type f -name "*.xml" -exec sed -i "" "s/&amp;#8217;/'/g" {} +
find . -type f -name "*.xml" -exec sed -i "" 's/&amp;#8221;/"/g' {} +
find . -type f -name "*.xml" -exec sed -i "" 's/&amp;#8220;/"/g' {} +
# fix up HTML files
find . -type f -name "*.html" -exec sed -i "" "s/&#8211;/--/g" {} +
find . -type f -name "*.html" -exec sed -i "" "s/&#8230;/.../g" {} +
find . -type f -name "*.html" -exec sed -i "" "s/&#8216;/'/g" {} +
find . -type f -name "*.html" -exec sed -i "" "s/&#8217;/'/g" {} +
find . -type f -name "*.html" -exec sed -i "" 's/&#8221;/"/g' {} +
ind . -type f -name "*.html" -exec sed -i "" 's/&#8220;/"/g' {} +
