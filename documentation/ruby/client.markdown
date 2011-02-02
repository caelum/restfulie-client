
## Entry points
	
Entry points are commonly defined through a resource retrieval or creation request. Restfulie allows you to use both type of entry points through its API.

### Resource retrieval entry point

Most systems will create a request retrieval entry point, which can be accessed as:

`city = Restfulie.at('http://localhost:3000/cities/5').get`

After that, the xml tree can be accessed and links followed. A typical city hypermedia file would be:

<pre>
&lt;city>
	&lt;name>Sao Paulo&lt;/name>
	&lt;population>
		&lt;size>18000000&lt;/size>
		&lt;growth>10&lt;/growth>
	&lt;/population>
	&lt;link rel="next_largest" href="http://localhost:3000/cities/18" />
&lt;/city>
</pre>

The information can be retrieved through the usual method invocations:

<pre>
puts city.name
puts "size #{city.population.size} and growth #{city.population.growth}"
</pre>

And links can be followed as:

<pre>
next_one = city.next_largest
</pre>

Note that the client application knows what the <b>rel</b> attribute <b>next_largest</b> means, but does not know what it's value stands for (Rio de Janeiro).

### Acessing the web response

In this case, you can access the http response through <b>web_response</b>, i.e.:

<pre>
city = Restfulie.at('http://localhost:3000/cities/5').get
puts "Response code #{city.web_response.code}"
</pre>

### Parsing a web response

 The return of such <b>web_response</b> method is an object of <i>Restfulie::Client::HTTPResponse</i> and allows you to access methods to check whether the request was successful or any other group of response codes:
<pre>
	city = Restfulie.at('http://localhost:3000/cities/5').get
	puts "Response code #{city.web_response.is_successful?}"
	puts "Response code #{city.web_response.is_client_error?}"
</pre>

### Resource creation entry point

If your server defines an entry point related to a resource creation, you can use the <b>create</b>	method as:

<pre>
resulting_city = Restfulie.at('http://localhost:3000/cities').create(city)
</pre>

Note that <b>resulting_city</b> seems to be the result of following a 201 response to its given Location header.
	
## Domain model binding example
Create your class and invoke the *uses_restfulie* method:

    class Order < ActiveRecord::Base
		    uses_restfulie
    end

One should first acquire the representation from the server through your common GET request and process it through the usual from_* methods:
<pre>
xml = Net::HTTP.get(URI.parse('http://www.caelum.com.br/orders/1'))
order = Order.from_xml(xml)
</pre>

or use the restfulie *from_web*:
<pre>order = Order.from_web 'http://www.caelum.com.br/orders/1'
</pre>

And now you can invoke all those actions in order to change your resource's state:

<pre>
order.refresh
order.update
order.destroy
order.pay
</pre>

Note that:
	* refresh is get</li>
	* update is put (and you have to put everything back)</li>
	* destroy is delete</li>
	* pay (unknown methods) is post</li>

### Media type and content negotiation

Restfulie entry point requests can make use of conneg by notifying the server which media type is being sent and which ones can be understood.

<b>Restfulie.as</b> will notify the server about the media type sent, setting the <b>content-type</b> header:

<pre>
Restfulie.at('http://caelum.com.br/orders').as('application/vnd_caelum_order+xml').create(order)
</pre>

<b>Restfulie.accepts</b> notify the server of which media types are understood by the client using the <b>Accepts</b> header:

<pre>
Restfulie.at('http://caelum.com.br/orders/2').accepts('application/vnd_caelum_order+xml').get
</pre>


### Resource format support</h3>

<p>Restfulie currently supports full application/atom+xml, xml+atom rel and json+links, besides atom feed and more.</p>
	

### Entry points: POST</h3>

In some cases, one wants to access an entry point through a <b>POST</b> request, i.e. adding a new Product to the system:

<pre>
class Product
	uses_restfulie
	entry_point_for.create.at 'http://www.caelum.com.br/product'
end

product = Product.remote_create Product.new
</pre>

### 304 cache support

If a self request is send to another URI, Restfulie will automatically use its <b>Etag</b> and <b>Last-modified</b> informations to execute the request. If the response is 304, it will return the object itself, indicating to the running software that there was no change: saving bandwidth.

Such <b>304</b> support is useful for systems where part or most of the requests are related to retrieving information, and even more important in polling systems: every request will not transfer the representation while it has not changed:

<pre>
order = Order.from_web order_uri
while !order.ready?
	sleep 1
	order = order.self
end
</pre>

