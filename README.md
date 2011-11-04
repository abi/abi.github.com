Based off mojombo's [blog](https://github.com/mojombo/mojombo.github.com).

Installation:

```sh
sudo gem install rdiscount jekyll
sudo pip install pygments

```

Resources:

* [Code highlighting](https://github.com/mojombo/jekyll/wiki/Liquid-Extensions)

Example:

{% highlight haskell %}
(sort x) == (quicksort x)
{% endhighlight %}


* [Generating the entire website client side and then, sending to the Github repo](https://github.com/mojombo/jekyll/issues/325)

Jeykll Watcher:

```sh
jekyll --server --auto
```


