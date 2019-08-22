using UnityEngine;

public class Shimmer : MonoBehaviour
{
    void Update()
    {
        GetComponent<Light>().range = Mathf.Lerp(7, 10 , Mathf.PingPong(Time.time * (1f/5f), 1));
    }
}
