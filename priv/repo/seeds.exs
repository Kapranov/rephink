alias Rephink.Repo
alias Rephink.Posts.Post

for _ <- 1..5 do
  Repo.insert!(%Post{
    title: Faker.Lorem.word,
    content: Faker.Lorem.sentence
  })
end
