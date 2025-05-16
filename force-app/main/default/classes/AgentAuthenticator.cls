/**
 * @description       : Returns the unique id of the current AuthSession to update the Messaging Session
 * @author            : tegeling@salesforce.com
 * @last modified on  : 03-01-2025
 * @last modified by  : tegeling@salesforce.com
 **/
public with sharing class AgentAuthenticator {
    @InvocableMethod(
      label='Get AuthSession identifier'
      description='Returns the unique id of the current AuthSession.'
    )
    /**
     * @description Method is used to get the SessionId Id of the current user
     * @author tegeling@salesforce.com | 03-01-2025
     * @return List<ActionResponse>
     **/
    public static List<ActionResponse> getAuthSessionId() {
      List<ActionResponse> responses = new List<ActionResponse>();
      ActionResponse response = new ActionResponse();
      response.authSessionId = Auth.SessionManagement.getCurrentSession()
        .get('SessionId');
      responses.add(response);
      return responses;
    }
  
    /**
     * @description Invocable response parameter
     **/
    public class ActionResponse {
      @InvocableVariable(description='Current AuthSession Id.')
      public String authSessionId;
    }
  }