## Hypermedia clients

Hypermedia support information is scattered aroud the entire documentation as this is a hypermedia based library..

## The response object

The response object to a restfulie http request allows access to four different methods, the
response <b>code</b>, its <b>body</b>, <b>headers</b> and an extra method called <b>resource</b>
that will try to unmarshall the response body according to its content type.

Restfulie uses <a href="http://github.com/caelum/medie">medie</a> to do the unmarshalling,
giving back a hypermedia aware object. The following example shows a typical response to
a xml request:

    > response = Restfulie.at(uri).accepts("application/xml").get
    > puts response.body

    <order>
        <link rel='payment' href='http://store.caelum.com.br/orders/2345/payment' />
        <items>
            <item>
                <id>Rest from scratch book</id>
            </item>
        </items>
        <price>1235.4</price>
    </order>

    > puts response.code
    200
    > puts response.headesr['Content-Type']
    ['application/xml']
    > resource = response.resource
    > puts resource.order.items[0].item.id
    "Rest from scratch book"

## Supported media types

Restfulie client comes with built in support to xml, json and opensearch and can be easily enhanced by providing your own driver through Medie. Check out medie's documentation on how to
support your own media type or contribute with Restfulie by posting your media
type handler at the mailing list.
	
## Link support

For representations that contain link elements in its body, such as this one in xml:

    <order>
        <link rel='payment' href='http://store.caelum.com.br/orders/2345/payment' />
        <items>
            <item>
                <id>Rest from scratch book</id>
            </item>
        </items>
        <price>1235.4</price>
    </order>

This link can be accessed by unmarshalling the resource and then accessing the link itself:

    response = Restfulie.at(uri).get

    # follow the payment link within the order
    response = response.resource.order.links.payment.follow.get

    # will print the payment body
    puts resource.body

Once you have invoked the <b>follow</b> method, the object returned is the same as a
<b>Restfulie.at()</b> invocation, a request dsl, which allows you to configure the
request as you wish, and execute it by invoking the proper http verb (i.e. get, post or put).

You can see an example of a full client navigating through links in the examples section.

## Link header support

If your service provides a link header such as:

`Link: <http://amundsen.com/examples/mazes/2d/ten-by-ten/0:north>; rel="start"; type="application/xml"`

This header can be accessed by using the headers.link and links method:

    resource = Restfulie.at(uri).get
    puts resource.headers.link("start").href

# following the link
`another_resource = resource.headers.link("start").follow.get`

