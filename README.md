<h1 align="center">bullet log parser</h2>

<p align="center">
  <a href="https://github.com/satoruk/bullet_log_parser/actions?query=workflow%3ACI"><img src="https://github.com/satoruk/bullet_log_parser/workflows/CI/badge.svg" height="20"/></a>
  <a href="https://badge.fury.io/rb/bullet_log_parser"><img src="https://badge.fury.io/rb/bullet_log_parser.svg" alt="Gem Version" height="20"></a>
</p>

This parser can help to convert the Bullet logs to prefer format you want.

## Install

```sh
bundle add bullet_log_parser --group "development, test"
# or
gem install bullet_log_parser
```

## Example

```sh
cat log/bullet.log | bullet_log_filter.rb
```

`bullet_log_filter.rb`

```rb
#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bullet_log_parser'

if __FILE__ == $PROGRAM_NAME
  results = BulletLogParser.uniq_log($stdin) do |ast|
    # skip no call stack
    next if ast[:stack].empty?

    stack = ast[:stack].last
    puts "#{stack[:filename]}:#{stack[:lineno]}:#{ast[:level]}"
    ast[:details].each do |detail|
      puts "  #{detail}"
    end
    puts ''
  end
  puts '-- summary ------'
  puts results
    .keys
    .map { |k| "#{k}:#{results[k].size}" }
    .join("\n")
end

```

## AST format

<details>
<summary>ast format example</summary>

```txt
2020-07-27 02:35:50[WARN] user: root
GET /posts
USE eager loading detected
  Post => [:comments]
  Add to your query: .includes([:comments])
Call stack
  /app/app/views/posts/_post.json.jbuilder:4:in `block in _app_views_posts__post_json_jbuilder__2280256895687227436_47114295576380'
  /app/app/views/posts/_post.json.jbuilder:3:in `_app_views_posts__post_json_jbuilder__2280256895687227436_47114295576380'
  /app/app/views/posts/index.json.jbuilder:1:in `_app_views_posts_index_json_jbuilder__4177424529561133656_47114295515920'
  /app/app/controllers/posts_controller.rb:13:in `index'
  /app/spec/requests/posts_spec.rb:45:in `block (4 levels) in <main>'
```

```json
{
  "detectedAt": "2020-07-27 02:35:50",
  "level": "WARN",
  "user": "root",
  "request": "GET /posts",
  "detection": "USE eager loading detected",
  "details": [
    "Post => [:comments]",
    "Add to your query: .includes([:comments])"
  ],
  "stack": [
    {
      "filename": "/app/app/views/posts/_post.json.jbuilder",
      "lineno": 4,
      "message": "in `block in _app_views_posts__post_json_jbuilder__2280256895687227436_47114295576380'"
    },
    {
      "filename": "/app/app/views/posts/_post.json.jbuilder",
      "lineno": 3,
      "message": "in `_app_views_posts__post_json_jbuilder__2280256895687227436_47114295576380'"
    },
    {
      "filename": "/app/app/views/posts/index.json.jbuilder",
      "lineno": 1,
      "message": "in `_app_views_posts_index_json_jbuilder__4177424529561133656_47114295515920'"
    },
    {
      "filename": "/app/app/controllers/posts_controller.rb",
      "lineno": 13,
      "message": "in `index'"
    },
    {
      "filename": "/app/spec/requests/posts_spec.rb",
      "lineno": 45,
      "message": "in `block (4 levels) in <main>'"
    }
  ]
}
```

</details>

[ci badge]: https://github.com/satoruk/bullet_log_parser/workflows/CI/badge.svg
