using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Tweetinvi;

namespace XtecTutorAPI.Models
{
    public class Twitter
    {
        public static async void twittear(String mensaje)
        {
            var userClient = new TwitterClient("iOVlqlrDtVEqG41j7xplu5Ldw", "TaLMzNmbk28N5wnOekGzWKSd0sEtws42HZh6565VfUp0CipLfz", "1409001341163347970-UV2AsbSAW362VTwISPk7Exiw8KGe6S", "96Z81MdkqTfThn5mkJCNOEn99EsfguuNsnANsPXIeG1it");
            var tweet = await userClient.Tweets.PublishTweetAsync(mensaje);
            Console.WriteLine("Se twitteó" + tweet);
        }
    }
}
