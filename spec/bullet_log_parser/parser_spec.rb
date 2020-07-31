# frozen_string_literal: true

RSpec.describe BulletLogParser::Parser do
  describe 'usecase' do
    it 'can be read sample log' do
      io = StringIO.new(<<~BULLET_LOG, 'r')
        2020-07-27 02:35:50[WARN] user: root
        GET /posts
        Need Counter Cache
          Post => [:comments]
        
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
        
      BULLET_LOG

      asts = []
      parser = described_class.new
      loop do
        str = io.gets
        break unless str

        parser.puts(str.chomp)
        next unless parser.terminated?

        asts << parser.ast unless parser.failed?

        parser = described_class.new
      end

      expect(asts.size).to be 2
      expect(asts).to eq(
        [
          {
            "detectedAt": '2020-07-27 02:35:50',
            "level": 'WARN',
            "user": 'root',
            "request": 'GET /posts',
            "detection": 'Need Counter Cache',
            "details": [
              'Post => [:comments]'
            ],
            "stack": []
          },
          {
            "detectedAt": '2020-07-27 02:35:50',
            "level": 'WARN',
            "user": 'root',
            "request": 'GET /posts',
            "detection": 'USE eager loading detected',
            "details": [
              'Post => [:comments]',
              'Add to your query: .includes([:comments])'
            ],
            "stack": [
              {
                "filename": '/app/app/views/posts/_post.json.jbuilder',
                "lineno": 4,
                "message": "in `block in _app_views_posts__post_json_jbuilder__2280256895687227436_47114295576380'"
              },
              {
                "filename": '/app/app/views/posts/_post.json.jbuilder',
                "lineno": 3,
                "message": "in `_app_views_posts__post_json_jbuilder__2280256895687227436_47114295576380'"
              },
              {
                "filename": '/app/app/views/posts/index.json.jbuilder',
                "lineno": 1,
                "message": "in `_app_views_posts_index_json_jbuilder__4177424529561133656_47114295515920'"
              },
              {
                "filename": '/app/app/controllers/posts_controller.rb',
                "lineno": 13,
                "message": "in `index'"
              },
              {
                "filename": '/app/spec/requests/posts_spec.rb',
                "lineno": 45,
                "message": "in `block (4 levels) in <main>'"
              }
            ]
          }
        ]
      )
    end
  end
end
