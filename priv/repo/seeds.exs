alias Rephink.Repo
alias Rephink.Todos.Todo
alias FakerElixir, as: Faker

Faker.set_locale(:en)

completed_faker = Faker.Boolean.boolean(0.1)
title_faker = Faker.Lorem.words(2..4)

for _ <- 1..15 do
  Repo.insert!(%Todo{
    title:  Faker.Lorem.words(2..4),
    completed: Faker.Boolean.boolean(0.1)
  })
end
