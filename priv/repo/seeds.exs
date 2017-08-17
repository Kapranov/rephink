alias Rephink.Repo
alias Rephink.Posts.Post

# version 1
initial_posts = [
  [
    {:title, Faker.Lorem.word},
    {:content, Faker.Lorem.sentence}
  ],
  [
    {:title, Faker.Lorem.word},
    {:content, Faker.Lorem.sentence}

  ],
  [
    {:title, Faker.Lorem.word},
    {:content, Faker.Lorem.sentence}
  ],
  [
    {:title, Faker.Lorem.word},
    {:content, Faker.Lorem.sentence}
  ]
]

for initial_post <- initial_posts do
  Repo.insert!(
    %Post{
      title: initial_post[:title],
      content: initial_post[:content]
    }
  )
end

# version 2
#for _ <- 1..15 do
#  Repo.insert!(%Post{
#    title: Faker.Lorem.word,
#    content: Faker.Lorem.sentence
#  })
#end
