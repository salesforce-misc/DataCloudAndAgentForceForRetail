public class FetchSessionId {
    @InvocableMethod(label='Get the loggedin user sessionId')
	public static List<String> fetchSessionId() {
        List<String> sessionIds = new List<String>();
        sessionIds.add(UserInfo.getSessionId());
		System.debug('Session id '+sessionIds);
        return sessionIds;
    }
}