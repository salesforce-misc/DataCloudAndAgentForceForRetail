@isTest
global class callServiceClassAPIMock implements HttpCalloutMock {

    global HttpResponse respond(HttpRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setStatusCode(200);
        res.setBody('{"data":[{"deltaType":"new","id":"0037y00000wOOhXAAW","snapshotType":"F","timestamp":"2025-04-09T10:22:39.220Z","versionStamp":"2025-04-09T10:06:42.837Z"}]}');
        return res;
    }
}