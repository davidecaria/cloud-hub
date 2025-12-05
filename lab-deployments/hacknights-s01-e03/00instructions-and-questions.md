# Scenario and Questions

## Scenario
You are working as a SOC analyst for a well-known manufacturing company. During routine checks, you notice that several workstations do not have the Endpoint Detection and Response (EDR) agent running, which raises immediate concerns about visibility and coverage. Later that evening, a user from the Finance department reports receiving an email from a supplier with a Word document attached, discussing the signature of an important contract. The user mentions that the file was delivered inside a password-protected ZIP archive, something this supplier has never done before. The user has already submitted the file for analysis, as this behavior seems unusual and potentially risky. Your task is to investigate the artifact, determine whether it is malicious, and assess the implications given the EDR gaps.

---

## Materials
- Archive: `open-me.zip` (password: `hacknights`)
- Tools:
  - `oledump.py` for stream analysis
  - `oletools` → `olevba` for macro extraction and inspection

---

## Questions
- **Q1:**  What type of artifact have you received? How can you guess some information about it?
- **Q2:** Based on the type of file, what are your first instincts and what do you plan to check?
- **Q3:** What tools can you run to confirm your suspicion? What is the conclusion after running them?
- **Q4:** Can you reveal the macro code? What makes it dangerous?
- **Q5:** Can you find the “marker”?
- **Q6:** Where will the macro create the malicious file?
- **Q7:** Based on the information gathered, what is the general behavior of this macro?
