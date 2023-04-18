public class checkEmail {

    @InvocableMethod(label = 'Check for Existing Email' description='Show Error if Email Address exists')
    public static void emailCheck(){
                   throw new emailException('email is present');
            }
}