export default function load() {
  let xhttp = new XMLHttpRequest();

  xhttp.onreadystatechange = function() {
    if (this.readyState === 4 && this.status === 200) {
      let data = JSON.parse(this.responseText);

      render(data.posts);
    }
  };

  xhttp.open("GET", "/api/posts", true);
  xhttp.send();
}

function render(posts) {
  let items = posts.reduce(function(acc, post) {
    let li = !posts.content? '<li class="blocked">' : '<li>';
    return acc + li + post.title + '</li>';
  }, "");

  let container = document.getElementById('post-container');
  container.innerHTML = '<ul>' + items + '</ul>';
}

console.log("App js loaded.");
