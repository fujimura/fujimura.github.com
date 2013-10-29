task default: [:build, :compile_markdown]

task :build do
  system %|runhaskell css.hs > main.css|
end

task :compile_markdown do
  Dir.glob("articles/*.md").each do |article_md|
    article,  = article_md.split("/").last.split "."
    cmd = %|
    pandoc
    --standalone
    --template sources/html5.html
    --include-after-body sources/footer.html
    --section-divs
    --css normalize.css
    --css article.css
    --from markdown
    --to html5
    --output #{article}.html
    #{article_md}
    |.gsub /[\s]+/, ' '
    system cmd
  end
end
