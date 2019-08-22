using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEngine;

public class GenerateNoise : MonoBehaviour
{
    private Texture2D noise = null;
    public int noiseWidth;
    public int noiseHeight;

    [ContextMenu("Go")]
    public void Start()
    {
        noise = new Texture2D(noiseWidth, noiseHeight);

        for (int x = 0; x < noiseWidth; x++)
        {
            for (int y = 0; y < noiseHeight; y++)
            {
                var val = Mathf.PerlinNoise(((float)x/noiseWidth) * 20f, ((float)y/noiseHeight) * 20f);
                noise.SetPixel(x, y, new Color(val, val, val, 1));
            }
        }

        noise.Apply();

        byte[] bytes = noise.EncodeToPNG();

        File.WriteAllBytes(Application.dataPath + "/../"  + "noiseSpecial.png", bytes);
    }
}
