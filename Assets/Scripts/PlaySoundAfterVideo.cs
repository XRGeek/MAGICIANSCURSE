using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Video;
using UnityEngine.UI;

public class PlaySoundAfterVideo : MonoBehaviour
{
    [SerializeField]
    private VideoPlayer vPlayer;
    [SerializeField]
    private AudioSource sfxSource;
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
    private int freezeFrame = 0;
    private IEnumerator coroutine;

    [SerializeField]
    private VideoClip video_German;
    [SerializeField]
    private VideoClip video_French;
    [SerializeField]
    private VideoClip video_English;

    private void Start()
    {
        playButton = GetComponent<Button>();
    }

    private void OnEnable()
    {
        if (vPlayer.clip == null)
        {
            switch (GleyLocalization.Manager.GetCurrentLanguage().ToString())
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

        vPlayer.time = currentTime;
        vPlayer.Prepare();

        vPlayer.playOnAwake = false;
        if (!videoPlayedOnce)
        {
            StartCoroutine("PlayVideo");
        }
        else
        {
            sfxSource.Play();
            vPlayer.Pause();
        }
    }

    private void OnDisable()
    {
        if (videoPlayedOnce)
            vPlayer.frame = freezeFrame;
        else
        {
            vPlayer.Pause();
        }
    }


    void Update()
    {
        if(vPlayer.isPlaying)
            currentTime = vPlayer.time;
    }

    public void PlaySFX()
    {
        sfxSource.Play();
    }

    IEnumerator PlayVideo()
    {
        if(currentTime==0)
        {
            vPlayer.Pause();

            sfxSource.Play();
            float sfxDuration = (float)sfxSource.clip.length;
            yield return new WaitForSeconds(sfxDuration);

        }

        vPlayer.Play();
        float duration = (float)vPlayer.clip.length - (float)currentTime;
        yield return new WaitForSeconds(duration);

        videoPlayedOnce = true;
        vPlayer.frame = freezeFrame;
        sfxSource.Play();
        playButton.image.color = Color.white;
        playButton.enabled = true;

        if (pState)
            pState.SolvePuzzle();
    }
}
