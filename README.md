> Plug in Elixir

In the ``Elixir`` world, ``Plug`` is the specification that enables
different frameworks to talk to different web servers in the ``Erlang``
VM. If you are  familiar with ``Ruby``, ``Plug`` tries to solve the same
problem that ``Rack`` does, just with a different approach.

Understanding the basics of how ``Plug`` works will make it easier to
get up to speed with ``Phoenix``,  and probably any other web framework
that is created for ``Elixir``.

**The role of a plug**

You can think of a ``Plug`` as a *piece of code* that receives a data
structure, does some sort of transformation, and returns this same data
structure, slightly modified. This data structure that a ``Plug``
receives and returns is usually called ``connection``, and represents
everything that there is to know about a request.

As plugs always receive and return a ``connection``, they can be easily
composable, forming what is called a *Plug pipeline*. Actually, that is
what usually happens. We receive a request, then each ``plug``
transforms this request a little bit and pass the result to the next
plug, until we get a response.

This ``connection`` that our plugs will be dealing with all the time is
a simple [Elixir struct][3], called ``%Plug.Conn{}`` which is [very well
documented][4].

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
![schema plug](plug.png "An exemplary image")
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━


**The two types of Plugs**


### 2017 August Oleg G.Kapranov

[1]: http://www.brianstorti.com/getting-started-with-plug-elixir/
[2]: https://habrahabr.ru/post/306334/
[3]: http://elixir-lang.org/getting-started/structs.html
[4]: https://hexdocs.pm/plug/Plug.Conn.html
