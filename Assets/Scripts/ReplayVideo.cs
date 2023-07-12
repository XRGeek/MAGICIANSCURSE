using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Video;
using UnityEngine.UI;

public class ReplayVideo : MonoBehaviour
{
    [SerializeField]
    private VideoPlayer vPlayer;
    [SerializeField]
    private Sprite PlayIcon;
    [SerializeField]
    private Sprite PauseIcon;
    private Button playButton;
    bool videoPlayedOnce;
    [SerializeField]
    private SimplePuzzleState pState;
    private double currentTime = 0;
    [SerializeField]
    private VideoClip video_German;
    [SerializeField]
    private VideoClip video_French;
    [SerializeField]
    private VideoClip video_English;

    public bool isOverrideLanguage = false;
    public string videoLanguage = "English";


    private void OnEnable()
    {
        if (vPlayer.clip == null)
        {
            var slanguage = GleyLocalization.Manager.GetCurrentLanguage().ToString();
            if (isOverrideLanguage)
            {
                slanguage = videoLanguage;
            }
            
            switch (slanguage)
            {
                // English
                case "English":
                    vPlayer.clip = video_English;
                    break;
                // French
                case "French":
                    vPlayer.clip = video_French;
                    break;
                // German
                case "German":
                    vPlayer.clip = video_German;
                    break;
            }
        }
        vPlayer.Prepare();
        vPlayer.time = currentTime;
        
        if (!videoPlayedOnce)
            StartCoroutine("PlayVideo");
        else
        {
            videoPlayedOnce = false;
            StartCoroutine("PlayVideo");
        }
    }

    /*
    private void Start()
    {
        playButton = GetComponent<Button>();
    }
    */


    private void OnDisable()
    {
        vPlayer.Pause();        
    }
    void Update()
    {
        if (vPlayer.isPlaying)
            currentTime = vPlayer.time;
    }

    public void PlayVPlayer()
    {
        if (vPlayer.isPlaying)
        {
            vPlayer.Pause();
            // playButton.image.sprite = PauseIcon;
            // playButton.image.color = new Color(1, 1, 1, 1);
            StopCoroutine("PlayVideo");
        }
        else if (vPlayer.isPaused)
        {
            StartCoroutine("PlayVideo");
        }
        else
            StartCoroutine("PlayVideo");
    }

    IEnumerator PlayVideo()
    {
        //playButton.image.color = new Color(0,0,0,0);

        vPlayer.Play();
        float duration = (float)vPlayer.clip.length - (float)currentTime;
        yield return new WaitForSeconds(duration);

        //playButton.image.sprite = PlayIcon;
        //playButton.image.color = new Color(1,1,1,1);
        videoPlayedOnce = true;

        if (pState)
            pState.SolvePuzzle();
    }
}
